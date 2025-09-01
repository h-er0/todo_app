import '../../models/setting_model.dart';

abstract class SettingRepository {
  Future<SettingModel> getSettings();
  Future<void> updateSetting(SettingModel settings);
}
