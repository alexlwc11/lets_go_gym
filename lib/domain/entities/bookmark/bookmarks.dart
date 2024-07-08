import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmarks.freezed.dart';
part 'bookmarks.g.dart';

@freezed
class Bookmarks with _$Bookmarks {
  const factory Bookmarks({
    @JsonKey(name: 'sports_center_ids') required int sportsCenterId,
  }) = _Bookmarks;

  factory Bookmarks.fromJson(Map<String, Object?> json) =>
      _$BookmarksFromJson(json);
}
