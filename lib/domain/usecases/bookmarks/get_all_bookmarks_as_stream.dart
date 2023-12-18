import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class GetAllBookmarksAsStream {
  final BookmarksRepository repository;

  GetAllBookmarksAsStream({required this.repository});

  Stream<List<Bookmark>> execute() => repository.getAllBookmarksAsStream();
}
