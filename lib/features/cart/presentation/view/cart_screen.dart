import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/resources/assets_manager.dart';
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/cart/presentation/view/widgets/cart_item_widget.dart';
import 'package:ecommerce_app/features/cart/presentation/view/widgets/total_price_and_checkout_botton.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CartCubit is a @lazySingleton: ONE cubit for the whole app (so the badge
    // and this screen share the same cart).
    // BlocProvider.value = "share an existing cubit, DON'T close it when this
    // screen closes". (BlocProvider(create:) would close it, and the next time
    // you open the cart the closed singleton would crash.)
    return BlocProvider.value(
      value: getIt<CartCubit>()..getCart(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cart',
            style: getMediumStyle(fontSize: 20, color: ColorManager.textColor),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: ImageIcon(
                AssetImage(IconsAssets.icSearch),
                color: ColorManager.primary,
              ),
            ),
          ],
        ),
        // BlocConsumer = BlocListener (one-time things like a SnackBar)
        //              + BlocBuilder  (draw the screen)
        body: BlocConsumer<CartCubit, CartStatus>(
          listenWhen: (_, state) => state.errorMessage != null,
          listener: (context, state) {
            // Items are already on screen → show the error as a SnackBar
            // instead of replacing the whole list with an error.
            if (!state.cart.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<CartCubit>();

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null && state.cart.isEmpty) {
              return Center(child: Text(state.errorMessage!));
            }
            if (state.cart.isEmpty) {
              return const Center(child: Text('Cart is empty'));
            }

            final items = state.cart.items;
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: Column(
                children: [
                  Expanded(
                    // the list of cart items ===============
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSize.s12.h),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        // Small spinner on top of the row being updated.
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CartItemWidget(
                              imagePath: item.imageCover,
                              title: item.title,
                              price: item.price.round(),
                              quantity: item.count,
                              onDeleteTap: () =>
                                  cubit.removeItem(item.productId),
                              onIncrementTap: (_) => cubit.increase(item),
                              onDecrementTap: (_) => cubit.decrease(item),
                            ),
                            if (state.updatingProductId == item.productId)
                              const CircularProgressIndicator(),
                          ],
                        );
                      },
                    ),
                  ),
                  // the total price and checkout button========
                  TotalPriceAndCheckoutBotton(
                    totalPrice: state.cart.totalPrice.round(),
                    checkoutButtonOnTap: () {},
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
