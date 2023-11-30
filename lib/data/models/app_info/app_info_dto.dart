import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';

part 'app_info_dto.g.dart';

@JsonSerializable()
class AppInfoDto {
  final int latestBuildVersion;
  final int minimumBuildVersion;

  AppInfoDto({
    required this.latestBuildVersion,
    required this.minimumBuildVersion,
  });

  factory AppInfoDto.fromJson(Map<String, Object?> json) =>
      _$AppInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoDtoToJson(this);
}

extension AppInfoConverter on AppInfoDto {
  AppInfo get toAppInfo {
    return AppInfo(
        latestBuildVersion: latestBuildVersion,
        minimumBuildVersion: minimumBuildVersion);
  }
}
