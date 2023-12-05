import 'package:json_annotation/json_annotation.dart';
import '../api_response.dart';

part 'api_response_error.g.dart';

@JsonSerializable()
class APIResponseError extends APIResponse implements Exception {
  final int? status;
  final String? name;
  final String? message;
  final Map<String, dynamic>? details;

  APIResponseError(this.status, this.name, this.message, this.details);

  factory APIResponseError.fromJson(Map<String, dynamic> json) =>
      _$APIResponseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$APIResponseErrorToJson(this);
}
