import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class UpdateDistrictsData {
  final DistrictsRepository repository;

  UpdateDistrictsData({required this.repository});

  Future<void> execute() => repository.updateDistrictData();
}
