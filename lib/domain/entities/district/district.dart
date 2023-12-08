import 'package:json_annotation/json_annotation.dart';

part 'district.g.dart';

@JsonSerializable()
class District {
  final int id;
  @JsonKey(name: 'region_id')
  final int regionId;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_zh')
  final String nameZh;

  District({
    required this.id,
    required this.regionId,
    required this.nameEn,
    required this.nameZh,
  });

  factory District.fromJson(Map<String, Object?> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}
