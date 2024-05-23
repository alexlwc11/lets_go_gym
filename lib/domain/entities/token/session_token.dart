import 'package:json_annotation/json_annotation.dart';

part 'session_token.g.dart';

@JsonSerializable()
class SessionToken {
  @JsonKey(name: 'session_token')
  final String sessionToken;
  @JsonKey(name: 'session_expired_at')
  final DateTime sessionTokenExpiredAt;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'refresh_expired_at')
  final DateTime refreshTokenExpiredAt;

  SessionToken({
    required this.sessionToken,
    required this.sessionTokenExpiredAt,
    required this.refreshToken,
    required this.refreshTokenExpiredAt,
  });

  factory SessionToken.fromJson(Map<String, dynamic> json) =>
      _$SessionTokenFromJson(json);

  Map<String, dynamic> toJson() => _$SessionTokenToJson(this);
}
