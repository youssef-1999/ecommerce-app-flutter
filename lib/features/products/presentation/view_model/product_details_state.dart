import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

/// State for the product DETAILS screen.
class ProductDetailsState extends Equatable {
  final ProductEntity? product; // null until loaded
  final bool isLoading;
  final String? errorMessage;

  const ProductDetailsState({
    this.product,
    this.isLoading = false,
    this.errorMessage,
  });

  ProductDetailsState copyWith({
    ProductEntity? product,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // cleared on every new state
    );
  }

  @override
  List<Object?> get props => [product, isLoading, errorMessage];
}
