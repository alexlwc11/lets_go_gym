import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/region/region_dto.dart';
import 'package:lets_go_gym/mock_data/mock_data.dart' as mock;

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
      // TODO remove mock data
      // final response = await _authClient.get(_regionsUrl);
      // final responseData = response.data as Map<String, dynamic>;
      final Map<String, dynamic> responseData = await Future.delayed(
        const Duration(seconds: 3),
        () => mock.regionsJson,
      );
      final regionsData = responseData['regions'] as List<Map<String, dynamic>>;

      return regionsData.map(RegionDto.fromJson).toList();
    } catch (error) {
      rethrow;
    }
  }
}
