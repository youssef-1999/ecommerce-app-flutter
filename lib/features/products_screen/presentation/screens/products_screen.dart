import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
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
    return BlocProvider(
      // "..getProducts()" creates the cubit AND starts loading right away
      create: (context) => getIt<ProductsCubit>()..getProducts(params),
      child: Scaffold(
        appBar: const HomeScreenAppBar(
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 7 / 9,
                ),
                itemBuilder: (context, index) {
                  return CustomProductWidget(product: state.products[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
