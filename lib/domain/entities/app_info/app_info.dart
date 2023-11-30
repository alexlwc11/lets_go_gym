import 'package:json_annotation/json_annotation.dart';

part 'app_info.g.dart';

@JsonSerializable()
class AppInfo {
  final int latestBuildVersion;
  final int minimumBuildVersion;

  AppInfo({
    required this.latestBuildVersion,
    required this.minimumBuildVersion,
  });

  factory AppInfo.fromJson(Map<String, Object?> json) =>
      _$AppInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoToJson(this);
}
