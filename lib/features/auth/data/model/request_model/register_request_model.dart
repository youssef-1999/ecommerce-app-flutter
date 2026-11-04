
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'password')
  String? password;
  @JsonKey(name: 'rePassword')
  String? rePassword;
  @JsonKey(name: 'phone')
  String? phone;

  RegisterRequestModel({this.name, this.email, this.password, this.rePassword, this.phone});

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);

 static RegisterRequestModel fromDomain(UserEntity user) {
    return RegisterRequestModel(
      name: user.name,
      email: user.email,
      rePassword: user.password,
      password: user.password,
      phone: user.phoneNumber,
    );
  }


  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}