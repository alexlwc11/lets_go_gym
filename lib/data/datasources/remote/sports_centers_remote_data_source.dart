import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/sports_center/sports_center_dto.dart';

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
      final response = await _authClient.get(_sportsCentersUrl);
      final responseData = response.data as Map<String, dynamic>;
      final sportsCentersData = responseData['sports_centers'] as List;

      return sportsCentersData.map((i) => SportsCenterDto.fromJson(i)).toList();
    } catch (error) {
      rethrow;
    }
  }
}
