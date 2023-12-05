import 'package:json_annotation/json_annotation.dart';

part 'data_info.g.dart';

@JsonSerializable()
class DataInfo {
  final DateTime? regionDataLastUpdatedAt;
  final DateTime? districtDataLastUpdatedAt;
  final DateTime? sportsCenterDataLastUpdatedAt;

  DataInfo({
    this.regionDataLastUpdatedAt,
    this.districtDataLastUpdatedAt,
    this.sportsCenterDataLastUpdatedAt,
  });

  factory DataInfo.fromJson(Map<String, Object?> json) =>
      _$DataInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DataInfoToJson(this);
}
