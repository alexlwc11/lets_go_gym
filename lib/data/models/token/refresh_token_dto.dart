import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_dto.g.dart';

@JsonSerializable()
class RefreshTokenDto {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  RefreshTokenDto({required this.refreshToken});

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDtoToJson(this);
}
