import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class GetAllBookmarks {
  final BookmarksRepository repository;

  GetAllBookmarks({required this.repository});

  Set<int> execute() => repository.getAllBookmarks();
}
