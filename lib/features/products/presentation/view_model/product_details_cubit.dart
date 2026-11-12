import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:ecommerce_app/features/products/presentation/view_model/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the product DETAILS screen.
@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUsecase getProductDetailsUsecase;

  ProductDetailsCubit({required this.getProductDetailsUsecase})
      : super(const ProductDetailsState());

  Future<void> getProductDetails(String productId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final product = await getProductDetailsUsecase(productId);
      emit(state.copyWith(isLoading: false, product: product));
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
