import 'package:lets_go_gym/core/constants.dart';
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
      // TODO remove mock data
      // final response = await _authClient.get(_regionsUrl);
      // final responseData = response.data as Map<String, dynamic>;
      final Map<String, dynamic> responseData = await Future.delayed(
        const Duration(seconds: 3),
        () => _regionsJson,
      );
      final regionsData = responseData['regions'] as List<Map<String, dynamic>>;

      return regionsData.map(RegionDto.fromJson).toList();
    } catch (error) {
      rethrow;
    }
  }
}

const _regionsJson = {
  'regions': [
    {
      'id': 1,
      'code': 'HK',
      'name_en': 'Hong Kong Island',
      'name_zh': '香港島',
    },
    {
      'id': 2,
      'code': 'KLN',
      'name_en': 'Kowloon',
      'name_zh': '九龍',
    },
    {
      'id': 3,
      'code': 'NT',
      'name_en': 'New Territories',
      'name_zh': '新界',
    }
  ],
};
