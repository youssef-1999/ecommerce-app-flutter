import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCartItemCountUsecase {
  final CartRepo _cartRepo;

  UpdateCartItemCountUsecase({required CartRepo cartRepo})
      : _cartRepo = cartRepo;

  Future<CartEntity> call(String productId, int count) async =>
      await _cartRepo.updateItemCount(productId, count);
}
