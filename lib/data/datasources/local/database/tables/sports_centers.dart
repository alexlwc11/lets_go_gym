import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart'
    as db;
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';

@TableIndex(name: 'sports_center_district_id', columns: {#districtId})
class SportsCenters extends BaseTable {
  IntColumn get districtId => integer()();
  TextColumn get nameEn => text()();
  TextColumn get nameZh => text()();
  TextColumn get addressEn => text()();
  TextColumn get addressZh => text()();
  TextColumn get phoneNumber => text()();
  IntColumn get hourlyQuota => integer().nullable()();
  IntColumn get monthlyQuota => integer().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
}

extension SportsCentersDataConverter on db.SportsCenter {
  SportsCenter get toEntity => SportsCenter(
        id: id,
        districtId: districtId,
        nameEn: nameEn,
        nameZh: nameZh,
        addressEn: addressEn,
        addressZh: addressZh,
        phoneNumber: phoneNumber,
        hourlyQuota: hourlyQuota,
        monthlyQuota: monthlyQuota,
        latitude: latitude,
        longitude: longitude,
      );

  static db.SportsCenter fromEntity(SportsCenter sportsCenter) =>
      db.SportsCenter(
        id: sportsCenter.id,
        districtId: sportsCenter.districtId,
        nameEn: sportsCenter.nameEn,
        nameZh: sportsCenter.nameZh,
        addressEn: sportsCenter.addressEn,
        addressZh: sportsCenter.addressZh,
        phoneNumber: sportsCenter.phoneNumber,
        hourlyQuota: sportsCenter.hourlyQuota,
        monthlyQuota: sportsCenter.monthlyQuota,
        latitude: sportsCenter.latitude,
        longitude: sportsCenter.longitude,
      );
}
