import 'dart:developer';

import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/district/district_dto.dart';

abstract class DistrictsRemoteDataSource {
  Future<List<DistrictDto>> getLatestDistricts();
}

class DistrictsRemoteDataSourceImpl implements DistrictsRemoteDataSource {
  final AuthClient _authClient;

  static String get _districtsUrl => '${ApiConstants.baseUrl}/districts';

  DistrictsRemoteDataSourceImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<List<DistrictDto>> getLatestDistricts() async {
    try {
      final response = await _authClient.get(_districtsUrl);
      final responseData = response.data as Map<String, dynamic>;
      final districtsData = responseData['districts'] as List;

      return districtsData.map((i) => DistrictDto.fromJson(i)).toList();
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
