import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_status.dart';
import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';
import 'package:ecommerce_app/features/products/presentation/view_model/products_cubit.dart';
import 'package:ecommerce_app/features/products/presentation/view_model/products_state.dart';
import 'package:ecommerce_app/features/products_screen/presentation/widgets/custom_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/home_screen_app_bar.dart';

class ProductsScreen extends StatelessWidget {
  /// Which products to load (e.g. one category). Empty = all products.
  final ProductsParamsEntity params;

  const ProductsScreen({super.key, this.params = const ProductsParamsEntity()});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // "..getProducts()" creates the cubit AND starts loading right away
      providers: [
        BlocProvider(
          create: (context) => getIt<ProductsCubit>()..getProducts(params),
        ),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: Scaffold(
        appBar: const HomeScreenAppBar(
          automaticallyImplyLeading: true,
        ),
        // BlocListener = DO something once (show a SnackBar) when adding finishes.
        body: BlocListener<CartCubit, CartStatus>(
          listenWhen: (prev, curr) =>
              // "adding just finished": before it was busy, now it isn't
              prev.updatingProductId != null &&
              curr.updatingProductId == null &&
              // only if THIS screen is the one on top (not hidden under the cart screen)
              (ModalRoute.of(context)?.isCurrent ?? false),
          listener: (context, state) {
            // the cubit tells us what happened ("Added…" / "Removed…" / error)
            final text = state.errorMessage ?? state.successMessage;
            if (text == null) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(text)));
          },
          // Stack = widgets on top of each other, like papers on a desk.
          child: Stack(
            children: [
              // ---------- Layer 1 (bottom): the products grid ----------
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }

                  if (state.products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: GridView.builder(
                      itemCount: state.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 7 / 9,
                      ),
                      itemBuilder: (context, index) {
                        return CustomProductWidget(
                            product: state.products[index]);
                      },
                    ),
                  );
                },
              ),

              // ---------- Layer 2 (top): spinner while adding to cart ----------
              BlocBuilder<CartCubit, CartStatus>(
                buildWhen: (prev, curr) =>
                    prev.updatingProductId != curr.updatingProductId,
                builder: (context, state) {
                  if (state.updatingProductId == null) {
                    return const SizedBox.shrink(); // = draw nothing
                  }
                  // Positioned.fill = cover the WHOLE screen, so the user
                  // can't tap "+" again while we wait.
                  return Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
