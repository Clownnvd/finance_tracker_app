// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 bool get reminderOn; bool get budgetAlertOn; bool get tipsOn;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.reminderOn, reminderOn) || other.reminderOn == reminderOn)&&(identical(other.budgetAlertOn, budgetAlertOn) || other.budgetAlertOn == budgetAlertOn)&&(identical(other.tipsOn, tipsOn) || other.tipsOn == tipsOn));
}


@override
int get hashCode => Object.hash(runtimeType,reminderOn,budgetAlertOn,tipsOn);

@override
String toString() {
  return 'AppSettings(reminderOn: $reminderOn, budgetAlertOn: $budgetAlertOn, tipsOn: $tipsOn)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 bool reminderOn, bool budgetAlertOn, bool tipsOn
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reminderOn = null,Object? budgetAlertOn = null,Object? tipsOn = null,}) {
  return _then(_self.copyWith(
reminderOn: null == reminderOn ? _self.reminderOn : reminderOn // ignore: cast_nullable_to_non_nullable
as bool,budgetAlertOn: null == budgetAlertOn ? _self.budgetAlertOn : budgetAlertOn // ignore: cast_nullable_to_non_nullable
as bool,tipsOn: null == tipsOn ? _self.tipsOn : tipsOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool reminderOn,  bool budgetAlertOn,  bool tipsOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.reminderOn,_that.budgetAlertOn,_that.tipsOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool reminderOn,  bool budgetAlertOn,  bool tipsOn)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.reminderOn,_that.budgetAlertOn,_that.tipsOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool reminderOn,  bool budgetAlertOn,  bool tipsOn)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.reminderOn,_that.budgetAlertOn,_that.tipsOn);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings extends AppSettings {
  const _AppSettings({required this.reminderOn, required this.budgetAlertOn, required this.tipsOn}): super._();
  

@override final  bool reminderOn;
@override final  bool budgetAlertOn;
@override final  bool tipsOn;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.reminderOn, reminderOn) || other.reminderOn == reminderOn)&&(identical(other.budgetAlertOn, budgetAlertOn) || other.budgetAlertOn == budgetAlertOn)&&(identical(other.tipsOn, tipsOn) || other.tipsOn == tipsOn));
}


@override
int get hashCode => Object.hash(runtimeType,reminderOn,budgetAlertOn,tipsOn);

@override
String toString() {
  return 'AppSettings(reminderOn: $reminderOn, budgetAlertOn: $budgetAlertOn, tipsOn: $tipsOn)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool reminderOn, bool budgetAlertOn, bool tipsOn
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reminderOn = null,Object? budgetAlertOn = null,Object? tipsOn = null,}) {
  return _then(_AppSettings(
reminderOn: null == reminderOn ? _self.reminderOn : reminderOn // ignore: cast_nullable_to_non_nullable
as bool,budgetAlertOn: null == budgetAlertOn ? _self.budgetAlertOn : budgetAlertOn // ignore: cast_nullable_to_non_nullable
as bool,tipsOn: null == tipsOn ? _self.tipsOn : tipsOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
