import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveCartItemUsecase {
  final CartRepo _cartRepo;

  RemoveCartItemUsecase({required CartRepo cartRepo}) : _cartRepo = cartRepo;

  Future<CartEntity> call(String productId) async =>
      await _cartRepo.removeItem(productId);
}
