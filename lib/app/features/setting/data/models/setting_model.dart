import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@freezed
abstract class SettingModel with _$SettingModel {
  const factory SettingModel({
    required bool askBeforeAction,
    required bool activeNotification,
    // Add more settingModel here in the future
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}
