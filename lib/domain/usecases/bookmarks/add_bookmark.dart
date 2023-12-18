import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class AddBookmark {
  final BookmarksRepository repository;

  AddBookmark({required this.repository});

  Future<void> execute(int sportsCenterId) =>
      repository.addBookmark(sportsCenterId);
}
