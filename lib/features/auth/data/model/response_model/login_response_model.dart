
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'token')
  String? token;

  LoginResponseModel({this.message, this.user, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  static List<LoginResponseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(LoginResponseModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'role')
  String? role;

  User({this.name, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static List<User> fromList(List<Map<String, dynamic>> list) {
    return list.map(User.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
  UserEntity toDomain() {
    return UserEntity(
      name: name,
      email: email,
    );
  }
}