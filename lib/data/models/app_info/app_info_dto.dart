import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/data/models/app_info/data_info_dto.dart';
import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';

part 'app_info_dto.g.dart';

@JsonSerializable()
class AppInfoDto {
  @JsonKey(name: 'latest_build_version')
  final int latestBuildVersion;
  @JsonKey(name: 'minimum_build_version')
  final int minimumBuildVersion;
  @JsonKey(name: 'data_info')
  final DataInfoDto dataInfoDto;

  AppInfoDto({
    required this.latestBuildVersion,
    required this.minimumBuildVersion,
    required this.dataInfoDto,
  });

  factory AppInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AppInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoDtoToJson(this);
}

extension AppInfoConverter on AppInfoDto {
  AppInfo get toAppInfo {
    return AppInfo(
      latestBuildVersion: latestBuildVersion,
      minimumBuildVersion: minimumBuildVersion,
      dataInfo: dataInfoDto.toDataInfo,
    );
  }
}
