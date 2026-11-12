// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_categories_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoriesResponseModel _$SubCategoriesResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubCategoriesResponseModel(
      data: json['data'] == null
          ? null
          : CategoryModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubCategoriesResponseModelToJson(
        SubCategoriesResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
