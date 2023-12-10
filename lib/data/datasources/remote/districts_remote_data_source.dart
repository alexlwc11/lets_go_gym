import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/district/district_dto.dart';
import 'package:lets_go_gym/mock_data/mock_data.dart' as mock;

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
      // TODO remove mock data
      // final response = await _authClient.get(_districtsUrl);
      // final responseData = response.data as Map<String, dynamic>;
      final Map<String, dynamic> responseData = await Future.delayed(
        const Duration(seconds: 3),
        () => mock.districtsJson,
      );
      final districtsData =
          responseData['districts'] as List<Map<String, dynamic>>;

      return districtsData.map(DistrictDto.fromJson).toList();
    } catch (error) {
      rethrow;
    }
  }
}
