// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingModel {

 bool get askBeforeAction; bool get activeNotification;
/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingModelCopyWith<SettingModel> get copyWith => _$SettingModelCopyWithImpl<SettingModel>(this as SettingModel, _$identity);

  /// Serializes this SettingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingModel&&(identical(other.askBeforeAction, askBeforeAction) || other.askBeforeAction == askBeforeAction)&&(identical(other.activeNotification, activeNotification) || other.activeNotification == activeNotification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,askBeforeAction,activeNotification);

@override
String toString() {
  return 'SettingModel(askBeforeAction: $askBeforeAction, activeNotification: $activeNotification)';
}


}

/// @nodoc
abstract mixin class $SettingModelCopyWith<$Res>  {
  factory $SettingModelCopyWith(SettingModel value, $Res Function(SettingModel) _then) = _$SettingModelCopyWithImpl;
@useResult
$Res call({
 bool askBeforeAction, bool activeNotification
});




}
/// @nodoc
class _$SettingModelCopyWithImpl<$Res>
    implements $SettingModelCopyWith<$Res> {
  _$SettingModelCopyWithImpl(this._self, this._then);

  final SettingModel _self;
  final $Res Function(SettingModel) _then;

/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? askBeforeAction = null,Object? activeNotification = null,}) {
  return _then(_self.copyWith(
askBeforeAction: null == askBeforeAction ? _self.askBeforeAction : askBeforeAction // ignore: cast_nullable_to_non_nullable
as bool,activeNotification: null == activeNotification ? _self.activeNotification : activeNotification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingModel].
extension SettingModelPatterns on SettingModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingModel value)  $default,){
final _that = this;
switch (_that) {
case _SettingModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingModel value)?  $default,){
final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool askBeforeAction,  bool activeNotification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that.askBeforeAction,_that.activeNotification);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool askBeforeAction,  bool activeNotification)  $default,) {final _that = this;
switch (_that) {
case _SettingModel():
return $default(_that.askBeforeAction,_that.activeNotification);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool askBeforeAction,  bool activeNotification)?  $default,) {final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that.askBeforeAction,_that.activeNotification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingModel implements SettingModel {
  const _SettingModel({required this.askBeforeAction, required this.activeNotification});
  factory _SettingModel.fromJson(Map<String, dynamic> json) => _$SettingModelFromJson(json);

@override final  bool askBeforeAction;
@override final  bool activeNotification;

/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingModelCopyWith<_SettingModel> get copyWith => __$SettingModelCopyWithImpl<_SettingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingModel&&(identical(other.askBeforeAction, askBeforeAction) || other.askBeforeAction == askBeforeAction)&&(identical(other.activeNotification, activeNotification) || other.activeNotification == activeNotification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,askBeforeAction,activeNotification);

@override
String toString() {
  return 'SettingModel(askBeforeAction: $askBeforeAction, activeNotification: $activeNotification)';
}


}

/// @nodoc
abstract mixin class _$SettingModelCopyWith<$Res> implements $SettingModelCopyWith<$Res> {
  factory _$SettingModelCopyWith(_SettingModel value, $Res Function(_SettingModel) _then) = __$SettingModelCopyWithImpl;
@override @useResult
$Res call({
 bool askBeforeAction, bool activeNotification
});




}
/// @nodoc
class __$SettingModelCopyWithImpl<$Res>
    implements _$SettingModelCopyWith<$Res> {
  __$SettingModelCopyWithImpl(this._self, this._then);

  final _SettingModel _self;
  final $Res Function(_SettingModel) _then;

/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? askBeforeAction = null,Object? activeNotification = null,}) {
  return _then(_SettingModel(
askBeforeAction: null == askBeforeAction ? _self.askBeforeAction : askBeforeAction // ignore: cast_nullable_to_non_nullable
as bool,activeNotification: null == activeNotification ? _self.activeNotification : activeNotification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
