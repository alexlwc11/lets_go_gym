import 'package:json_annotation/json_annotation.dart';

part 'bookmark_dto.g.dart';

@JsonSerializable()
class BookmarkDto {
  @JsonKey(name: 'sports_center_ids')
  final Set<int>? sportsCenterIds;

  BookmarkDto({
    this.sportsCenterIds,
  });

  factory BookmarkDto.fromJson(Map<String, dynamic> json) =>
      _$BookmarkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkDtoToJson(this);
}
