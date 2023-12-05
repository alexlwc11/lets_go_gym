import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class GetCurrentDataInfo {
  final AppInfoRepository repository;

  GetCurrentDataInfo({required this.repository});

  Future<DataInfo> execute() async => repository.getCurrentDataInfo();
}
