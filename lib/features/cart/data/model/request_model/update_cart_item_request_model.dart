import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_request_model.g.dart';

/// PUT /cart/{productId}  body: { "count": "2" }
@JsonSerializable()
class UpdateCartItemRequestModel {
  // The API docs send count as a string, so we do the same.
  @JsonKey(name: 'count')
  final String count;

  UpdateCartItemRequestModel({required this.count});

  /// Lets the rest of the app pass a normal int.
  UpdateCartItemRequestModel.fromCount(int count) : count = count.toString();

  factory UpdateCartItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestModelToJson(this);
}
