import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepo {
 Future<UserEntity> login(UserEntity user);
}