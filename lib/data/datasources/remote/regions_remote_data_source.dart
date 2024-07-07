import 'dart:developer';

import 'package:lets_go_gym/core/utils/constant/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/region/region_dto.dart';

abstract class RegionsRemoteDataSource {
  Future<List<RegionDto>> getLatestRegions();
}

class RegionsRemoteDataSourceImpl implements RegionsRemoteDataSource {
  final AuthClient _authClient;

  static String get _regionsUrl => '${ApiConstants.baseUrl}/regions';

  RegionsRemoteDataSourceImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<List<RegionDto>> getLatestRegions() async {
    try {
      final response = await _authClient.get(_regionsUrl);
      final responseData = response.data as Map<String, dynamic>;
      final regionsData = responseData['regions'] as List;

      return regionsData.map((i) => RegionDto.fromJson(i)).toList();
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
