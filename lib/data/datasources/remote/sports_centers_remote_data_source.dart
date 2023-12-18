import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/sports_center/sports_center_dto.dart';
import 'package:lets_go_gym/mock_data/mock_data.dart' as mock;

abstract class SportsCentersRemoteDataSource {
  Future<List<SportsCenterDto>> getLatestSportsCenters();
}

class SportsCentersRemoteDataSourceImpl
    implements SportsCentersRemoteDataSource {
  final AuthClient _authClient;

  static String get _sportsCentersUrl =>
      '${ApiConstants.baseUrl}/sports_centers';

  SportsCentersRemoteDataSourceImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<List<SportsCenterDto>> getLatestSportsCenters() async {
    try {
      // TODO remove mock data
      // final response = await _authClient.get(_sportsCentersUrl);
      // final responseData = response.data as Map<String, dynamic>;
      final Map<String, dynamic> responseData = await Future.delayed(
        const Duration(seconds: 3),
        () => mock.sportsCentersJson,
      );
      final sportsCentersData =
          responseData['sports_centers'] as List<Map<String, dynamic>>;

      return sportsCentersData.map(SportsCenterDto.fromJson).toList();
    } catch (error) {
      rethrow;
    }
  }
}
