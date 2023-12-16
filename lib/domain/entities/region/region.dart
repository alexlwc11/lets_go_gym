import 'package:freezed_annotation/freezed_annotation.dart';

part 'region.freezed.dart';
part 'region.g.dart';

@freezed
class Region with _$Region {
  const factory Region({
    required int id,
    required String code,
    @JsonKey(name: "name_en") required String nameEn,
    @JsonKey(name: "name_zh") required String nameZh,
  }) = _Region;

  factory Region.fromJson(Map<String, Object?> json) => _$RegionFromJson(json);
}
