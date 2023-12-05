import 'package:lets_go_gym/data/models/app_info/data_info_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _regionDataLastUpdatedKey = 'regionDataLastUpdated';
const _districtDataLastUpdatedKey = 'districtDataLastUpdated';
const _sportsCenterDataLastUpdatedKey = 'sportsCenterDataLastUpdated';

abstract class AppInfoLocalDataSource {
  Future<DataInfoDto> getCurrentDataInfo();
  Future<void> updateRegionDataLastUpdated({DateTime? date});
  Future<void> updateDistrictDataLastUpdated({DateTime? date});
  Future<void> updateSportsCenterDataLastUpdated({DateTime? date});
}

class AppInfoLocalDataSourceImpl implements AppInfoLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AppInfoLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<DataInfoDto> getCurrentDataInfo() async {
    final regionDataLastUpdated = DateTime.tryParse(
        _sharedPreferences.getString(_regionDataLastUpdatedKey) ?? '');
    final districtDataLastUpdated = DateTime.tryParse(
        _sharedPreferences.getString(_districtDataLastUpdatedKey) ?? '');
    final sportsCenterDataLastUpdated = DateTime.tryParse(
        _sharedPreferences.getString(_sportsCenterDataLastUpdatedKey) ?? '');

    return DataInfoDto(
      regionDataLastUpdatedAt: regionDataLastUpdated,
      districtDataLastUpdatedAt: districtDataLastUpdated,
      sportsCenterDataLastUpdatedAt: sportsCenterDataLastUpdated,
    );
  }

  @override
  Future<void> updateRegionDataLastUpdated({DateTime? date}) async {
    await _sharedPreferences.setString(
      _regionDataLastUpdatedKey,
      (date ?? DateTime.now()).toString(),
    );
  }

  @override
  Future<void> updateDistrictDataLastUpdated({DateTime? date}) async {
    await _sharedPreferences.setString(
      _districtDataLastUpdatedKey,
      (date ?? DateTime.now()).toString(),
    );
  }

  @override
  Future<void> updateSportsCenterDataLastUpdated({DateTime? date}) async {
    await _sharedPreferences.setString(
      _sportsCenterDataLastUpdatedKey,
      (date ?? DateTime.now()).toString(),
    );
  }
}
