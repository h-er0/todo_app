// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingModel _$SettingModelFromJson(Map<String, dynamic> json) =>
    _SettingModel(
      askBeforeAction: json['askBeforeAction'] as bool,
      activeNotification: json['activeNotification'] as bool,
    );

Map<String, dynamic> _$SettingModelToJson(_SettingModel instance) =>
    <String, dynamic>{
      'askBeforeAction': instance.askBeforeAction,
      'activeNotification': instance.activeNotification,
    };
