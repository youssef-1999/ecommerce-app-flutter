import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce_app/features/products/presentation/view_model/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the products GRID screen.
@injectable
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUsecase getProductsUsecase;

  ProductsCubit({required this.getProductsUsecase})
      : super(const ProductsState());

  /// Example: getProducts(ProductsParamsEntity(categoryId: id))
  /// or getProducts() with no params to show all products.
  Future<void> getProducts(
      [ProductsParamsEntity params = const ProductsParamsEntity()]) async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await getProductsUsecase(params);
      emit(state.copyWith(isLoading: false, products: products));
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
