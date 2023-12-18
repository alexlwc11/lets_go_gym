import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    required int id,
    @JsonKey(name: 'sports_center_id') required int sportsCenterId,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, Object?> json) =>
      _$BookmarkFromJson(json);
}
