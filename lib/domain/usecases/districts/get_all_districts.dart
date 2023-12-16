import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class GetAllDistricts {
  final DistrictsRepository repository;

  GetAllDistricts({required this.repository});

  Future<List<District>> execute() => repository.getAllDistricts();
}
