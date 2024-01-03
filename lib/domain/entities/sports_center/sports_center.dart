import 'package:freezed_annotation/freezed_annotation.dart';

part 'sports_center.freezed.dart';
part 'sports_center.g.dart';

@freezed
class SportsCenter with _$SportsCenter {
  const factory SportsCenter({
    required int id,
    @JsonKey(name: 'district_id') required int districtId,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_zh') required String nameZh,
    @JsonKey(name: 'address_en') required String addressEn,
    @JsonKey(name: 'address_zh') required String addressZh,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'hourly_quota') int? hourlyQuota,
    @JsonKey(name: 'monthly_quota') int? monthlyQuota,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
  }) = _SportsCenter;

  factory SportsCenter.fromJson(Map<String, Object?> json) =>
      _$SportsCenterFromJson(json);
}
