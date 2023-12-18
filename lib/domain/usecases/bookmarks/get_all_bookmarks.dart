import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class GetAllBookmarks {
  final BookmarksRepository repository;

  GetAllBookmarks({required this.repository});

  Future<List<Bookmark>> execute() => repository.getAllBookmarks();
}
