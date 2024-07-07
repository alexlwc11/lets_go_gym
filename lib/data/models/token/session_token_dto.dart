import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/token/session_token.dart';

part 'session_token_dto.g.dart';

@JsonSerializable()
class SessionTokenDto {
  @JsonKey(name: 'session_token')
  final String sessionToken;
  @JsonKey(name: 'session_expired_at')
  final DateTime sessionTokenExpiredAt;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'refresh_expired_at')
  final DateTime refreshTokenExpiredAt;

  SessionTokenDto({
    required this.sessionToken,
    required this.sessionTokenExpiredAt,
    required this.refreshToken,
    required this.refreshTokenExpiredAt,
  });

  factory SessionTokenDto.fromJson(Map<String, dynamic> json) =>
      _$SessionTokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionTokenDtoToJson(this);
}

extension SessionTokenConverter on SessionTokenDto {
  SessionToken get toEntity {
    return SessionToken(
      sessionToken: sessionToken,
      sessionTokenExpiredAt: sessionTokenExpiredAt,
      refreshToken: refreshToken,
      refreshTokenExpiredAt: refreshTokenExpiredAt,
    );
  }
}
