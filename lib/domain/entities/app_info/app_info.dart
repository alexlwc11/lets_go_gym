import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';

part 'app_info.g.dart';

@JsonSerializable(explicitToJson: true)
class AppInfo {
  final int latestBuildVersion;
  final int minimumBuildVersion;
  final DataInfo dataInfo;

  AppInfo({
    required this.latestBuildVersion,
    required this.minimumBuildVersion,
    required this.dataInfo,
  });

  factory AppInfo.fromJson(Map<String, Object?> json) =>
      _$AppInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoToJson(this);
}
