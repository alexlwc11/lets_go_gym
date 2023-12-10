import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';

part 'district_dto.g.dart';

@JsonSerializable()
class DistrictDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'region_id')
  final int regionId;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_zh')
  final String nameZh;

  DistrictDto({
    required this.id,
    required this.regionId,
    required this.nameEn,
    required this.nameZh,
  });

  factory DistrictDto.fromJson(Map<String, Object?> json) =>
      _$DistrictDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictDtoToJson(this);
}

extension DistrictConverter on DistrictDto {
  District get toEntity {
    return District(
      id: id,
      regionId: regionId,
      nameEn: nameEn,
      nameZh: nameZh,
    );
  }
}
