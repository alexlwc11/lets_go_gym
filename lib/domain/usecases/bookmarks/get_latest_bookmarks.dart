import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class GetLatestBookmarks {
  final BookmarksRepository repository;

  GetLatestBookmarks({required this.repository});

  Future<void> execute() => repository.getLatestBookmarks();
}
