# Category Feature: Clean Architecture Guide

This guide builds `lib/features/category` with **Clean Architecture**, using the same
structure as `features/auth`. When you finish, the Categories tab will show real data from the
API in place of the hard-coded "Laptops & Electronics" items.

The whole feature uses **one entity: `CategoryEntity`**.

## Contents

1. [What is Clean Architecture?](#1-what-is-clean-architecture)
2. [Feature folder structure](#2-feature-folder-structure)
3. [The API contract](#3-the-api-contract)
4. [Domain layer](#4-domain-layer-the-heart)
5. [Data layer](#5-data-layer-talking-to-the-outside-world)
6. [Dependency injection & code generation](#6-dependency-injection--code-generation)
7. [Presentation layer](#7-presentation-layer-what-the-user-sees)
8. [Walkthrough: one tap, all layers](#8-walkthrough-one-tap-all-layers)
9. [Rules checklist](#9-rules-checklist)
10. [Common problems](#10-common-problems)
11. [Next steps](#11-next-steps)

---

## 1. What is Clean Architecture?

Clean Architecture splits a feature into **layers**. Each layer has one job, and layers may only
depend on each other in **one direction**.

### 1.1 The three layers

| Layer | Folder | Its job | Knows about | Analogy |
|---|---|---|---|---|
| **Domain** | `domain/` | The business rules: *what* the app can do | **Nothing** else (pure Dart) | The restaurant menu |
| **Data** | `data/` | *How* to get the data: API, JSON, local storage | Domain | The kitchen |
| **Presentation** | `presentation/` | Screens and screen state (Cubit) | Domain | The waiter and dining room |

### 1.2 The dependency rule (the most important idea)

> **Source code dependencies point inward, toward the Domain.**
> The Domain never imports anything from Data or Presentation.

```
        ┌──────────────────────────────────────────────┐
        │                PRESENTATION                  │
        │   CategoriesTab · widgets · CategoryCubit    │
        │                      │                       │
        │                      ▼                       │
        │   ┌──────────────────────────────────────┐   │
        │   │               DOMAIN                 │   │
        │   │  CategoryEntity                      │   │
        │   │  CategoryRepo (abstract)             │   │
        │   │  GetCategoriesUsecase                │   │
        │   │  GetSubCategoriesUsecase             │   │
        │   └──────────────────────────────────────┘   │
        │                      ▲                       │
        │                      │                       │
        │   CategoryRepoImpl · DataSource · Api · Model│
        │                    DATA                      │
        └──────────────────────────────────────────────┘
```

Both arrows point **into** the Domain:
- **Presentation → Domain:** the cubit calls use cases and receives `CategoryEntity`.
- **Data → Domain:** `CategoryRepoImpl` *implements* the domain's `CategoryRepo`, and models convert themselves *into* `CategoryEntity`.

**Why is this useful?**
- You can swap Dio for another HTTP client, or add a local cache, and only the **Data** layer changes.
- You can redesign the whole screen, and only the **Presentation** layer changes.
- The Domain is pure Dart, so it's easy to unit test with no Flutter and no network.

### 1.3 How does the Domain get data if it can't import the Data layer?

This is the clever part, called **dependency inversion**:

1. The Domain declares an **abstract** `CategoryRepo`: "someone will give me categories."
2. The Data layer writes `CategoryRepoImpl implements CategoryRepo`: "I'm that someone."
3. **Dependency injection** (`getIt` + `injectable`) connects them at runtime.

The use case only ever sees `CategoryRepo`. It never knows that `CategoryRepoImpl`, Dio or JSON exist.

### 1.4 Who converts what?

Each layer speaks its own "language":

| Layer | Object | Shape |
|---|---|---|
| Data | `CategoryModel` | Mirrors the JSON exactly (`_id`, `slug`, nullable fields…) |
| Domain | `CategoryEntity` | Only what the app needs (`id`, `name`, `image`), never null |
| Presentation | `CategoryState` | Entities + UI flags (`isLoading`, `selectedIndex`, `errorMessage`) |

The conversion **Model → Entity** happens in the Data layer (`toDomain()`), so JSON details never leak
into the Domain or the UI.

---

## 2. Feature folder structure

```
lib/features/category/
│
├── domain/                                   ◄── 1. build first (no dependencies)
│   ├── entity/
│   │   └── category_entity.dart              the ONE entity
│   ├── repository/
│   │   └── category_repo.dart                abstract contract
│   └── usecases/
│       ├── get_categories_usecase.dart
│       └── get_sub_categories_usecase.dart
│
├── data/                                     ◄── 2. depends on domain
│   ├── model/
│   │   ├── category_model.dart               shared by both responses
│   │   └── response_model/
│   │       ├── categories_response_model.dart
│   │       └── sub_categories_response_model.dart
│   ├── api/
│   │   └── category_api.dart                 Retrofit
│   ├── data_source/
│   │   └── category_data_source.dart         abstract + remote impl
│   └── repository/
│       └── category_repo_impl.dart           implements domain contract
│
└── presentation/                             ◄── 3. depends on domain
    ├── view_model/
    │   ├── category_state.dart
    │   └── category_cubit.dart
    └── view/
        ├── categories_tab.dart
        └── widgets/
            ├── categories_list.dart
            ├── category_item.dart
            ├── category_card_item.dart
            ├── sub_categories_list.dart
            └── sub_category_item.dart
```

Shared files outside the feature (`lib/core/`):
- `core/network/endpoints.dart`: the URLs
- `core/network/error/error_model.dart`: the app's error types
- `core/di/`: `getIt` setup and the `Dio` module

> `*.g.dart` files are generated (step 6) and aren't listed here.
> The widgets under `presentation/view/widgets/` already exist in
> `lib/features/main_layout/categories/presentation/`. Step 7.3 moves them.

---

## 3. The API contract

Before writing code, look at what the server returns.

### `GET /categories`: list of categories

`data` is a **list**:

```json
{
  "results": 10,
  "metadata": { "currentPage": 1, "numberOfPages": 1, "limit": 40 },
  "data": [
    {
      "_id": "6439d61c0049ad0b52b90051",
      "name": "Music",
      "slug": "music",
      "image": "https://ecommerce.routemisr.com/Route-Academy-categories/1681511964020.jpeg",
      "createdAt": "2023-04-14T22:39:24.365Z",
      "updatedAt": "2023-04-14T22:39:24.365Z"
    }
  ]
}
```

### `GET /categories/{id}`: subcategories

`data` is **one object**, with the same fields as one list item above plus `__v`:

```json
{
  "data": {
    "_id": "6439d61c0049ad0b52b90051",
    "name": "Music",
    "slug": "music",
    "image": "https://ecommerce.routemisr.com/Route-Academy-categories/1681511964020.jpeg",
    "createdAt": "2023-04-14T22:39:24.365Z",
    "updatedAt": "2023-04-14T22:39:24.365Z",
    "__v": 0
  }
}
```

**Takeaway:** both responses contain the same "category" shape, so there's
**one model** (`CategoryModel`) and **one entity** (`CategoryEntity`). Only the wrapper differs:
a list in one case, a single object in the other.

> ⚠️ `GET /categories/{id}` returns **one** category, so the grid on the right shows one item.
> To show many subcategories, use `GET /categories/{id}/subcategories` (`data` is a list).
> Section 5.6 shows the two-line change; no other layer changes. That's Clean Architecture paying off.

---

## 4. Domain layer: the heart

> **Rule:** files in `domain/` import only other `domain/` files.
> No `dio`, no `json_annotation`, no `flutter`, no `data/`.
>
> *Pragmatic exception:* use cases carry the `@injectable` annotation (as in `features/auth`)
> so `getIt` can build them. It's just a label, not logic.

### 4.1 Entity

An **entity** is a plain Dart object holding only what the app needs. It's used for both
categories and subcategories.

**File:** `lib/features/category/domain/entity/category_entity.dart` ✅ *(already created)*

```dart
/// One entity used for both categories and subcategories.
class CategoryEntity {
  final String id;
  final String name;
  final String image;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.image,
  });
}
```

> **Why non-nullable?** The Data layer handles missing JSON values (`?? ''`), so the rest of
> the app never has to deal with `null`.

### 4.2 Repository contract

An **abstract class**: a promise of *what* can be done, with no *how*.
The Data layer will fulfil this promise.

**File:** `lib/features/category/domain/repository/category_repo.dart`

```dart
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';

abstract class CategoryRepo {
  Future<List<CategoryEntity>> getCategories();
  Future<List<CategoryEntity>> getSubCategories(String categoryId);
}
```

> `getSubCategories` returns a `List` even though the API returns one object. The UI shows a
> grid, and a grid wants a list. This also keeps the contract stable if the endpoint changes later.

### 4.3 Use cases

A **use case** is one action the user can perform. It's the place for business rules
(for example "hide categories with no image"). The `call` method lets you call the object like a
function: `getCategoriesUsecase()`.

**File:** `lib/features/category/domain/usecases/get_categories_usecase.dart`

```dart
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/domain/repository/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUsecase {
  final CategoryRepo _categoryRepo;

  GetCategoriesUsecase({required CategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo;

  Future<List<CategoryEntity>> call() async => await _categoryRepo.getCategories();
}
```

**File:** `lib/features/category/domain/usecases/get_sub_categories_usecase.dart`

```dart
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/domain/repository/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubCategoriesUsecase {
  final CategoryRepo _categoryRepo;

  GetSubCategoriesUsecase({required CategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo;

  Future<List<CategoryEntity>> call(String categoryId) async =>
      await _categoryRepo.getSubCategories(categoryId);
}
```

Notice that both use cases depend on `CategoryRepo` (abstract), **not** on `CategoryRepoImpl`.

---

## 5. Data layer: talking to the outside world

> **Rule:** files in `data/` may import `domain/` and `core/`, never `presentation/`.

The Data layer, from the inside out:

```
CategoryRepoImpl  ──calls──►  CategoryDataSource  ──calls──►  CategoryApi  ──HTTP──►  server
       │                                                          │
       └── converts CategoryModel ──toDomain()──► CategoryEntity ◄┘ returns models
```

### 5.1 Endpoints (core)

**File:** `lib/core/network/endpoints.dart`

```dart
class Endpoints {
  static const String login = '/auth/signin';
  static const String register = '/auth/signup';

  // Category feature
  static const String categories = '/categories';
  static const String subCategories = '/categories/{id}';
}
```

`{id}` is a placeholder. Retrofit fills it in through `@Path('id')`.

### 5.2 Model (shared)

A **model** mirrors the JSON exactly. `json_serializable` generates `fromJson`/`toJson`.
`toDomain()` is the bridge into the Domain layer.

**File:** `lib/features/category/data/model/category_model.dart`

```dart
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id') // the API uses "_id", we want "id" in Dart
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'slug')
  String? slug;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Data → Domain: keep only what the app needs, replace null with ''.
  CategoryEntity toDomain() => CategoryEntity(
        id: id ?? '',
        name: name ?? '',
        image: image ?? '',
      );
}
```

> `__v` isn't listed, and that's fine: `json_serializable` ignores JSON keys it doesn't know.

### 5.3 Response models (the wrappers)

**File:** `lib/features/category/data/model/response_model/categories_response_model.dart`

For `GET /categories`, where `data` is a **list**:

```dart
import 'package:ecommerce_app/features/category/data/model/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response_model.g.dart';

@JsonSerializable()
class CategoriesResponseModel {
  @JsonKey(name: 'results')
  int? results;
  @JsonKey(name: 'metadata')
  Metadata? metadata;
  @JsonKey(name: 'data')
  List<CategoryModel>? data;

  CategoriesResponseModel({this.results, this.metadata, this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseModelToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: 'currentPage')
  int? currentPage;
  @JsonKey(name: 'numberOfPages')
  int? numberOfPages;
  @JsonKey(name: 'limit')
  int? limit;

  Metadata({this.currentPage, this.numberOfPages, this.limit});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
```

**File:** `lib/features/category/data/model/response_model/sub_categories_response_model.dart`

For `GET /categories/{id}`, where `data` is a **single object**:

```dart
import 'package:ecommerce_app/features/category/data/model/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_categories_response_model.g.dart';

@JsonSerializable()
class SubCategoriesResponseModel {
  @JsonKey(name: 'data')
  CategoryModel? data; // one object → no List

  SubCategoriesResponseModel({this.data});

  factory SubCategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoriesResponseModelToJson(this);
}
```

> Compare `List<CategoryModel>?` with `CategoryModel?`. That's the only real difference between
> the two responses.

### 5.4 API (Retrofit)

Retrofit turns this abstract class into real Dio calls in `category_api.g.dart`.

**File:** `lib/features/category/data/api/category_api.dart`

```dart
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/endpoints.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/categories_response_model.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/sub_categories_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'category_api.g.dart';

@injectable
@RestApi()
abstract class CategoryApi {
  @factoryMethod
  factory CategoryApi(Dio dio) = _CategoryApi;

  @GET(Endpoints.categories)
  Future<CategoriesResponseModel> getCategories();

  // @Path('id') replaces {id} in '/categories/{id}'
  @GET(Endpoints.subCategories)
  Future<SubCategoriesResponseModel> getSubCategories(
      @Path('id') String categoryId);
}
```

> The `Dio` it receives is the singleton from `core/di/module/dio.module.dart`,
> which already has the `baseUrl` set.

### 5.5 Data source

An abstract class plus a **remote** implementation. Later you can add a
`CategoryLocalDataSource` (cache) without touching the Domain or the UI.

**File:** `lib/features/category/data/data_source/category_data_source.dart`

```dart
import 'package:ecommerce_app/features/category/data/api/category_api.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/categories_response_model.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/sub_categories_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryDataSource {
  Future<CategoriesResponseModel> getCategories();
  Future<SubCategoriesResponseModel> getSubCategories(String categoryId);
}

@Injectable(as: CategoryDataSource)
class CategoryRemoteDataSource implements CategoryDataSource {
  final CategoryApi _categoryApi;
  CategoryRemoteDataSource(this._categoryApi);

  @override
  Future<CategoriesResponseModel> getCategories() async =>
      await _categoryApi.getCategories();

  @override
  Future<SubCategoriesResponseModel> getSubCategories(String categoryId) async =>
      await _categoryApi.getSubCategories(categoryId);
}
```

> `@Injectable(as: CategoryDataSource)` means: "when someone asks `getIt` for a
> `CategoryDataSource`, give them a `CategoryRemoteDataSource`."

### 5.6 Repository implementation (fulfils the Domain contract)

This is where the Data layer **plugs into** the Domain. It:
1. calls the data source,
2. converts models into entities (`toDomain()`),
3. turns `DioException` into the app's `ErrorModel`, so the upper layers never see Dio.

**File:** `lib/features/category/data/repository/category_repo_impl.dart`

```dart
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/category/data/data_source/category_data_source.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/domain/repository/category_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  final CategoryDataSource _categoryDataSource;
  CategoryRepoImpl(this._categoryDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _categoryDataSource.getCategories();
      // data is a list → convert every item
      return (response.data ?? [])
          .map((category) => category.toDomain())
          .toList();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<List<CategoryEntity>> getSubCategories(String categoryId) async {
    try {
      final response = await _categoryDataSource.getSubCategories(categoryId);
      final category = response.data;
      // data is ONE object → wrap it in a list (empty if missing)
      return category == null ? [] : [category.toDomain()];
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }
}
```

> **Switching to `/categories/{id}/subcategories` later?**
> 1. In `SubCategoriesResponseModel`: `List<CategoryModel>? data;`
> 2. Here: `return (response.data ?? []).map((c) => c.toDomain()).toList();`
>
> The Domain and Presentation layers don't change at all.

---

## 6. Dependency injection & code generation

### 6.1 What `getIt` does here

`getIt` is a box of ready-made objects. The `@injectable` annotations tell it how to build each one.
When the UI asks for `getIt<CategoryCubit>()`, it builds the whole chain automatically:

```
CategoryCubit
 ├── GetCategoriesUsecase ─┐
 └── GetSubCategoriesUsecase ─┴── CategoryRepo  →  CategoryRepoImpl
                                                     └── CategoryDataSource  →  CategoryRemoteDataSource
                                                                                  └── CategoryApi
                                                                                        └── Dio (singleton)
```

This is how the abstract `CategoryRepo` in the Domain gets its real `CategoryRepoImpl`
**without the Domain ever importing it**.

### 6.2 Run build_runner

From the project root:

```bash
dart run build_runner build --delete-conflicting-outputs
```

It generates:
- `category_model.g.dart` and the two `*_response_model.g.dart` files (json_serializable),
- `category_api.g.dart` (Retrofit),
- the new registrations in `lib/core/di/di.config.dart` (injectable).

> Red errors on `_CategoryApi` or `_$CategoryModelFromJson` *before* running this are normal.
> Run it again after adding the cubit in section 7.

---

## 7. Presentation layer: what the user sees

> **Rule:** files in `presentation/` may import `domain/` and `core/`, **never `data/`**.
> The UI knows `CategoryEntity` and the use cases. It doesn't know models, Dio or JSON.

```
CategoriesTab (BlocProvider)
   └── BlocBuilder<CategoryCubit, CategoryState>
         ├── CategoriesList      ← state.categories      (List<CategoryEntity>)
         └── SubCategoriesList   ← state.subCategories   (List<CategoryEntity>)
```

### 7.1 State

**State** is a snapshot of everything the screen needs at one moment.
The cubit replaces it with a new snapshot, and the screen redraws.

**File:** `lib/features/category/presentation/view_model/category_state.dart`

```dart
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  final List<CategoryEntity> categories; // left list
  final List<CategoryEntity> subCategories; // right grid (same entity)
  final int selectedIndex;
  final bool isLoading; // loading the left list
  final bool isSubLoading; // loading the right grid
  final String? errorMessage;

  const CategoryState({
    this.categories = const [],
    this.subCategories = const [],
    this.selectedIndex = 0,
    this.isLoading = false,
    this.isSubLoading = false,
    this.errorMessage,
  });

  /// The category currently highlighted on the left, or null if the list is empty.
  CategoryEntity? get selectedCategory =>
      categories.isEmpty ? null : categories[selectedIndex];

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    List<CategoryEntity>? subCategories,
    int? selectedIndex,
    bool? isLoading,
    bool? isSubLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubLoading: isSubLoading ?? this.isSubLoading,
      // NOT "?? this.errorMessage" on purpose: every new state clears the
      // old error unless you pass a new one. Otherwise an old error would stick forever.
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [categories, subCategories, selectedIndex, isLoading, isSubLoading, errorMessage];
}
```

> **Why `Equatable`?** It compares states by *value*. If the cubit emits a state identical to the
> current one, `BlocBuilder` skips the redraw.

### 7.2 Cubit

The **Cubit** holds the state and exposes methods the UI can call. It talks to the
**use cases only**, never to the repo or the API directly.

**File:** `lib/features/category/presentation/view_model/category_cubit.dart`

```dart
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/features/category/domain/usecases/get_sub_categories_usecase.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetSubCategoriesUsecase getSubCategoriesUsecase;

  CategoryCubit({
    required this.getCategoriesUsecase,
    required this.getSubCategoriesUsecase,
  }) : super(const CategoryState());

  /// Loads the left list, then automatically loads the first category's subcategories.
  Future<void> getCategories() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await getCategoriesUsecase();
      emit(state.copyWith(
        isLoading: false,
        categories: categories,
        selectedIndex: 0,
      ));
      if (categories.isNotEmpty) {
        await selectCategory(0);
      }
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Called when the user taps a category on the left.
  Future<void> selectCategory(int index) async {
    final category = state.categories[index];
    emit(state.copyWith(
      selectedIndex: index,
      isSubLoading: true,
      subCategories: [], // clear the old grid while loading
    ));
    try {
      final subCategories = await getSubCategoriesUsecase(category.id);
      // The user tapped another category while we waited → ignore this stale answer.
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, subCategories: subCategories));
    } on ErrorModel catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, errorMessage: e.message));
    } catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, errorMessage: e.toString()));
    }
  }
}
```

> The cubit catches `ErrorModel`, which is a **core** type, not `DioException`.
> The repo already translated the error, so the Presentation layer stays independent of Dio.

### 7.3 Move the existing widgets into the feature

Run from the project root:

```bash
mkdir -p lib/features/category/presentation/view
git mv lib/features/main_layout/categories/presentation/categories_tab.dart lib/features/category/presentation/view/categories_tab.dart
git mv lib/features/main_layout/categories/presentation/widgets lib/features/category/presentation/view/widgets
```

Fix the import in `lib/features/main_layout/main_layout.dart`:

```dart
// old
import 'package:ecommerce_app/features/main_layout/categories/presentation/categories_tab.dart';
// new
import 'package:ecommerce_app/features/category/presentation/view/categories_tab.dart';
```

`category_item.dart` needs **no changes**. The files below do.

### 7.4 `categories_tab.dart`: provide the cubit and react to state

**File:** `lib/features/category/presentation/view/categories_tab.dart`

```dart
import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/categories_list.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/sub_categories_list.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_cubit.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider creates the cubit (via getIt) and shares it with every widget below.
    // "..getCategories()" starts loading right after the cubit is created.
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>()..getCategories(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder re-runs "builder" every time the cubit emits a new state.
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        // 1) First load → spinner
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.primary),
          );
        }

        // 2) Nothing to show → error/empty message + retry
        final selectedCategory = state.selectedCategory;
        if (selectedCategory == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'No categories found',
                  style: getRegularStyle(color: ColorManager.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSize.s12),
                ElevatedButton(
                  onPressed: () => context.read<CategoryCubit>().getCategories(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // 3) Data ready → the two-column layout
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12, vertical: AppPadding.p12),
          child: Row(
            children: [
              CategoriesList(
                categories: state.categories,
                selectedIndex: state.selectedIndex,
                onItemClick: (index) =>
                    context.read<CategoryCubit>().selectCategory(index),
              ),
              const SizedBox(width: AppSize.s16),
              SubCategoriesList(
                category: selectedCategory,
                subCategories: state.subCategories,
                isLoading: state.isSubLoading,
                errorMessage: state.errorMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

> **`context.read<CategoryCubit>()`** finds the cubit that `BlocProvider` created above.
> Use it inside callbacks (`onPressed`, `onTap`). It grabs the cubit without causing a rebuild.

### 7.5 `categories_list.dart`: now a "dumb" widget

The selected index used to live in this widget's `setState`. Now the **cubit owns it**, so the widget
becomes stateless: it receives data and reports taps. Widgets that only display what they're given
are easy to reuse and test.

**File:** `lib/features/category/presentation/view/widgets/categories_list.dart`

```dart
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int selectedIndex;
  final void Function(int index) onItemClick;

  const CategoriesList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: ColorManager.containerGray,
        border: Border(
            // set the border for only 3 sides
            top: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3)),
            left: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3)),
            bottom: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3))),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.s12),
          bottomLeft: Radius.circular(AppSize.s12),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.s12),
          bottomLeft: Radius.circular(AppSize.s12),
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryItem(
            index,
            categories[index].name,
            selectedIndex == index,
            onItemClick,
          ),
        ),
      ),
    ));
  }
}
```

### 7.6 `sub_categories_list.dart`: show real data

**File:** `lib/features/category/presentation/view/widgets/sub_categories_list.dart`

```dart
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/font_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/category_card_item.dart';
import 'package:flutter/material.dart';

import 'sub_category_item.dart';

class SubCategoriesList extends StatelessWidget {
  final CategoryEntity category;
  final List<CategoryEntity> subCategories; // same entity type
  final bool isLoading;
  final String? errorMessage;

  const SubCategoriesList({
    super.key,
    required this.category,
    required this.subCategories,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: CustomScrollView(
        slivers: <Widget>[
          // category title
          SliverToBoxAdapter(
            child: Text(
              category.name,
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s14),
            ),
          ),
          // the category card
          SliverToBoxAdapter(
            child: CategoryCardItem(
                category.name, category.image, goToCategoryProductsListScreen),
          ),
          // spinner / message / grid
          if (isLoading)
            SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            )
          else if (subCategories.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  errorMessage ?? 'No subcategories',
                  style: getRegularStyle(color: ColorManager.primary),
                ),
              ),
            )
          else
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: subCategories.length,
                  (context, index) => SubCategoryItem(
                      subCategories[index].name,
                      subCategories[index].image,
                      goToCategoryProductsListScreen),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: AppSize.s8,
                  crossAxisSpacing: AppSize.s8,
                ))
        ],
      ),
    );
  }

  goToCategoryProductsListScreen() {
    // todo implement this function
  }
}
```

> `if (...) ... else if (...) ... else ...` inside a list is called **collection-if**.
> It picks which widget goes into the list without a separate method.

### 7.7 Network images: `category_card_item.dart` and `sub_category_item.dart`

`image` is now a **URL**, so `Image.asset(...)` won't work. Use `CachedNetworkImage`
(already in `pubspec.yaml`). It downloads the image once, caches it, and lets you show a
placeholder while loading and a fallback image if the download fails.

**File:** `lib/features/category/presentation/view/widgets/category_card_item.dart`
(replace the imports and the `Image.asset(...)` block)

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/resources/assets_manager.dart';
// ... keep the other imports

            // Background image for the category
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: ColorManager.containerGray,
              ),
              errorWidget: (context, url, error) => Image.asset(
                ImageAssets.categoryCardImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
```

**File:** `lib/features/category/presentation/view/widgets/sub_category_item.dart`
(replace the imports and the `Image.asset(...)` inside `ClipRRect`)

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/resources/assets_manager.dart';
// ... keep the other imports

              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: ColorManager.containerGray,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    ImageAssets.subcategoryCardImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
```

### 7.8 Regenerate and run

`CategoryCubit` is a new `@injectable` class, so regenerate once more:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Open the **Category** tab (second icon in the bottom bar). You should see:
1. a spinner,
2. the 10 categories on the left (Music, Men's Fashion, …), with the first one selected,
3. its title and image card on the right, and the item from `GET /categories/{id}` in the grid,
4. a short spinner on the right each time you tap another category.

---

## 8. Walkthrough: one tap, all layers

What happens when the user taps **"Electronics"** on the left:

| # | Layer | Code | What happens |
|---|---|---|---|
| 1 | Presentation | `CategoryItem` → `onItemClick(9)` | The widget reports the tap |
| 2 | Presentation | `CategoryCubit.selectCategory(9)` | Emits `selectedIndex: 9, isSubLoading: true` → spinner shows |
| 3 | Domain | `GetSubCategoriesUsecase('6439d2d1…')` | Asks the abstract `CategoryRepo` |
| 4 | Data | `CategoryRepoImpl.getSubCategories` | (`getIt` gave the use case this implementation) |
| 5 | Data | `CategoryRemoteDataSource` → `CategoryApi` | `GET /categories/6439d2d1…` |
| 6 | Data | json_serializable | JSON → `SubCategoriesResponseModel` → `CategoryModel` |
| 7 | Data | `CategoryModel.toDomain()` | `CategoryModel` → `CategoryEntity` |
| 8 | Domain | use case returns | `List<CategoryEntity>` back to the cubit |
| 9 | Presentation | `emit(subCategories: [...], isSubLoading: false)` | `BlocBuilder` rebuilds → the grid shows the item |

If the network fails at step 5: `DioException` → (repo) `ErrorModel` → (cubit) `errorMessage` →
(UI) the message shows under the category card.

---

## 9. Rules checklist

### Who can import whom

| File in… | may import `domain/` | may import `data/` | may import `presentation/` | may import `dio` / `json_annotation` | may import `flutter` |
|---|:-:|:-:|:-:|:-:|:-:|
| `domain/` | ✅ | ❌ | ❌ | ❌ | ❌ |
| `data/` | ✅ | ✅ | ❌ | ✅ | ❌ |
| `presentation/` | ✅ | ❌ | ✅ | ❌ | ✅ |

Quick self-check: search your `presentation/` folder for `data/`, and your `domain/` folder
for `data/`, `dio` or `flutter`. Both searches should find nothing.

### Build checklist

**Domain**
- [x] `CategoryEntity` *(created)*
- [ ] `CategoryRepo` (abstract)
- [ ] `GetCategoriesUsecase`, `GetSubCategoriesUsecase`

**Data**
- [ ] `endpoints.dart`: `categories` (`/categories`) and `subCategories` (`/categories/{id}`)
- [ ] `CategoryModel` (shared) with `toDomain()`
- [ ] `CategoriesResponseModel` (list) and `SubCategoriesResponseModel` (single object)
- [ ] `CategoryApi`, `CategoryDataSource`, `CategoryRepoImpl`

**Presentation**
- [ ] `CategoryState`, `CategoryCubit`
- [ ] Moved widgets into `presentation/view/` and fixed the import in `main_layout.dart`
- [ ] Updated `categories_tab.dart`, `categories_list.dart`, `sub_categories_list.dart`, `category_card_item.dart`, `sub_category_item.dart`
- [ ] Deleted the now-empty `lib/features/main_layout/categories/` folder

**Generate**
- [ ] `dart run build_runner build --delete-conflicting-outputs`

---

## 10. Common problems

| Problem | Cause / fix |
|---|---|
| `GetIt: Object/factory with type CategoryCubit is not registered` | You didn't re-run `build_runner` after adding `@injectable`. Run it again. |
| `The method '_$CategoryModelFromJson' isn't defined` | The `.g.dart` file wasn't generated yet, or the `part '...g.dart';` filename doesn't match the file's name. |
| `type 'Null' is not a subtype of type 'String'` | A model field isn't nullable. Keep model fields `String?` and use `?? ''` in `toDomain()`. |
| `type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'` | The response model says `List<CategoryModel>` but JSON `data` is one object (or the other way around). Compare with section 3. |
| Categories reload every time you switch tabs | `MainLayout` rebuilds the tab on each switch, so `BlocProvider` creates a new cubit. Move the `BlocProvider` up into `MainLayout`, or register the cubit as `@lazySingleton`. |

---

## 11. Next steps

- **Home tab:** `CustomCategoryWidget` in `home_tab.dart` still shows the hard-coded "men's fashion".
  Reuse `GetCategoriesUsecase` (a Domain use case can serve any screen; that's the point of the layer).
- **Real subcategories:** switch to `/categories/{id}/subcategories` and follow the note in section 5.6.
- **Navigation:** implement `goToCategoryProductsListScreen` so tapping an item opens `ProductsScreen`
  filtered by that id.
- **Tests:** the Domain layer is pure Dart, so you can unit test the use cases with a fake `CategoryRepo`
  and no network.
