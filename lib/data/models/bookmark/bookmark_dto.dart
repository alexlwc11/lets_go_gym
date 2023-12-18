import 'package:json_annotation/json_annotation.dart';
import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';

part 'bookmark_dto.g.dart';

@JsonSerializable()
class BookmarkDto {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'sports_center_id')
  final int? sportsCenterId;

  BookmarkDto({
    this.id,
    this.sportsCenterId,
  });

  factory BookmarkDto.fromJson(Map<String, Object?> json) =>
      _$BookmarkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkDtoToJson(this);
}

extension BookmarkConverter on BookmarkDto {
  Bookmark get toEntity {
    if (id == null) throw Exception('id cannot be null');
    if (sportsCenterId == null) throw Exception('sportCenterId cannot be null');

    return Bookmark(
      id: id!,
      sportsCenterId: sportsCenterId!,
    );
  }
}
