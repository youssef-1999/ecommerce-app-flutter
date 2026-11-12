import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

/// State for the products GRID screen.
class ProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      // NOT "?? this.errorMessage" on purpose: every new state clears the old error
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage];
}
