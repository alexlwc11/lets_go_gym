import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class CheckIfBookmarked {
  final BookmarksRepository repository;

  CheckIfBookmarked({required this.repository});

  Future<bool> execute(int sportsCenterId) =>
      repository.checkIfBookmarked(sportsCenterId);
}
