// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIResponseError _$APIResponseErrorFromJson(Map<String, dynamic> json) =>
    APIResponseError(
      json['status'] as int?,
      json['name'] as String?,
      json['message'] as String?,
      json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$APIResponseErrorToJson(APIResponseError instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'message': instance.message,
      'details': instance.details,
    };
