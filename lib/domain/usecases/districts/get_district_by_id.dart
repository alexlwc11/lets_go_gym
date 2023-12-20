import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class GetDistrictById {
  final DistrictsRepository repository;

  GetDistrictById({required this.repository});

  Future<District?> execute(int id) => repository.getDistrictById(id);
}
