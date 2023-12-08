import 'package:json_annotation/json_annotation.dart';

part 'region.g.dart';

@JsonSerializable()
class Region {
  final int id;
  final String code;
  @JsonKey(name: "name_en")
  final String nameEn;
  @JsonKey(name: "name_zh")
  final String nameZh;

  Region({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameZh,
  });

  factory Region.fromJson(Map<String, Object?> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);
}
