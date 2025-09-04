import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/features/setting/data/data_sources/setting_local_data_source.dart';
import 'package:todo_app/app/features/setting/data/models/setting_model.dart';
import 'package:todo_app/app/features/setting/data/repository/interfaces/setting_repository.dart';

final settingRepositoryProvider = Provider<SettingRepositoryImpl>(
  (ref) => SettingRepositoryImpl(localDataSource: SettingLocalDataSource()),
);

class SettingRepositoryImpl implements SettingRepository {
  final SettingLocalDataSource localDataSource;

  SettingRepositoryImpl({required this.localDataSource});
  @override
  Future<SettingModel> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> updateSetting(SettingModel settings) async {
    await localDataSource.updateSetting(settings);
  }
}
