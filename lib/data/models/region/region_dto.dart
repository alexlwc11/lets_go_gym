import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';

part 'region_dto.g.dart';

@JsonSerializable()
class RegionDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_zh')
  final String nameZh;

  RegionDto({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameZh,
  });

  factory RegionDto.fromJson(Map<String, Object?> json) =>
      _$RegionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDtoToJson(this);
}

extension RegionConverter on RegionDto {
  Region get toEntity {
    return Region(
      id: id,
      code: code,
      nameEn: nameEn,
      nameZh: nameZh,
    );
  }
}
