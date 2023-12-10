import 'package:lets_go_gym/domain/repositories/regions_repository.dart';

class UpdateRegionsData {
  final RegionsRepository repository;

  UpdateRegionsData({required this.repository});

  Future<void> execute() => repository.updateRegionData();
}
