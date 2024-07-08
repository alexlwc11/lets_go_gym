import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class UpdateBookmarks {
  final BookmarksRepository repository;

  UpdateBookmarks({required this.repository});

  Future<void> execute(Set<int> sportsCenterIds) =>
      repository.updateBookmarks(sportsCenterIds);
}
