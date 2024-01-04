import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class CheckIfBookmarkedAsStream {
  final BookmarksRepository repository;

  CheckIfBookmarkedAsStream({required this.repository});

  Stream<bool> execute(int sportsCenterId) =>
      repository.checkIfBookmarkedAsStream(sportsCenterId);
}
