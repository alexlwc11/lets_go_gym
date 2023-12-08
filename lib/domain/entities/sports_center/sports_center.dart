import 'package:json_annotation/json_annotation.dart';

part 'sports_center.g.dart';

@JsonSerializable()
class SportsCenter {
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
  final String phoneNumber;
  @JsonKey(name: 'hourly_quota')
  final int hourlyQuota;
  @JsonKey(name: 'monthly_quota')
  final int monthlyQuota;

  SportsCenter({
    required this.id,
    required this.districtId,
    required this.nameEn,
    required this.nameZh,
    required this.addressEn,
    required this.addressZh,
    required this.phoneNumber,
    required this.hourlyQuota,
    required this.monthlyQuota,
  });

  factory SportsCenter.fromJson(Map<String, Object?> json) =>
      _$SportsCenterFromJson(json);

  Map<String, dynamic> toJson() => _$SportsCenterToJson(this);
}
