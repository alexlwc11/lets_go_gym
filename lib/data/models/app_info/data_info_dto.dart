import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';

part 'data_info_dto.g.dart';

@JsonSerializable()
class DataInfoDto {
  @JsonKey(name: 'region_data_last_updated_at')
  final DateTime? regionDataLastUpdatedAt;
  @JsonKey(name: 'district_data_last_updated_at')
  final DateTime? districtDataLastUpdatedAt;
  @JsonKey(name: 'sports_center_data_last_updated_at')
  final DateTime? sportsCenterDataLastUpdatedAt;

  DataInfoDto({
    this.regionDataLastUpdatedAt,
    this.districtDataLastUpdatedAt,
    this.sportsCenterDataLastUpdatedAt,
  });

  factory DataInfoDto.fromJson(Map<String, Object?> json) =>
      _$DataInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataInfoDtoToJson(this);
}

extension DataInfoConverter on DataInfoDto {
  DataInfo get toDataInfo {
    return DataInfo(
      regionDataLastUpdatedAt: regionDataLastUpdatedAt ?? DateTime.now(),
      districtDataLastUpdatedAt: districtDataLastUpdatedAt ?? DateTime.now(),
      sportsCenterDataLastUpdatedAt:
          sportsCenterDataLastUpdatedAt ?? DateTime.now(),
    );
  }
}
