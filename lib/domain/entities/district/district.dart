import 'package:freezed_annotation/freezed_annotation.dart';

part 'district.freezed.dart';
part 'district.g.dart';

@freezed
class District with _$District {
  const factory District({
    required int id,
    @JsonKey(name: 'region_id') required int regionId,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_zh') required String nameZh,
  }) = _District;

  factory District.fromJson(Map<String, Object?> json) =>
      _$DistrictFromJson(json);
}
