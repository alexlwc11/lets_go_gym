import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';

part 'sports_center_dto.g.dart';

@JsonSerializable()
class SportsCenterDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'district_id')
  final int districtId;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_zh')
  final String nameZh;
  @JsonKey(name: 'address_en')
  final String addressEn;
  @JsonKey(name: 'address_zh')
  final String addressZh;
  @JsonKey(name: 'phone_numbers')
  final String phoneNumbers;
  @JsonKey(name: 'hourly_quota')
  final int? hourlyQuota;
  @JsonKey(name: 'monthly_quota')
  final int? monthlyQuota;
  @JsonKey(name: 'latitude_dd', fromJson: double.parse)
  final double? latitude;
  @JsonKey(name: 'longitude_dd', fromJson: double.parse)
  final double? longitude;

  SportsCenterDto({
    required this.id,
    required this.districtId,
    required this.nameEn,
    required this.nameZh,
    required this.addressEn,
    required this.addressZh,
    required this.phoneNumbers,
    this.hourlyQuota,
    this.monthlyQuota,
    this.latitude,
    this.longitude,
  });

  factory SportsCenterDto.fromJson(Map<String, Object?> json) =>
      _$SportsCenterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SportsCenterDtoToJson(this);
}

extension SportsCenterConverter on SportsCenterDto {
  SportsCenter get toEntity {
    return SportsCenter(
      id: id,
      districtId: districtId,
      nameEn: nameEn,
      nameZh: nameZh,
      addressEn: addressEn,
      addressZh: addressZh,
      phoneNumbers: phoneNumbers,
      hourlyQuota: hourlyQuota,
      monthlyQuota: monthlyQuota,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
