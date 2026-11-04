
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'token')
  String? token;

  RegisterResponseModel({this.message, this.user, this.token});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => _$RegisterResponseModelFromJson(json);

  static List<RegisterResponseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(RegisterResponseModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
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
    UserEntity toDomain() {
    return UserEntity(
      name: name,
      email: email,
     
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}