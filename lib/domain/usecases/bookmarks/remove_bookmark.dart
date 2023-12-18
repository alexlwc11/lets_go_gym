import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class RemoveBookmark {
  final BookmarksRepository repository;

  RemoveBookmark({required this.repository});

  Future<void> execute(int sportsCenterId) =>
      repository.removeBookmark(sportsCenterId);
}
