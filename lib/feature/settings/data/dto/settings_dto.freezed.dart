// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsDto {

 String get user_id; bool get reminder_on; bool get budget_alert_on; bool get tips_on;
/// Create a copy of SettingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDtoCopyWith<SettingsDto> get copyWith => _$SettingsDtoCopyWithImpl<SettingsDto>(this as SettingsDto, _$identity);

  /// Serializes this SettingsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDto&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.reminder_on, reminder_on) || other.reminder_on == reminder_on)&&(identical(other.budget_alert_on, budget_alert_on) || other.budget_alert_on == budget_alert_on)&&(identical(other.tips_on, tips_on) || other.tips_on == tips_on));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user_id,reminder_on,budget_alert_on,tips_on);

@override
String toString() {
  return 'SettingsDto(user_id: $user_id, reminder_on: $reminder_on, budget_alert_on: $budget_alert_on, tips_on: $tips_on)';
}


}

/// @nodoc
abstract mixin class $SettingsDtoCopyWith<$Res>  {
  factory $SettingsDtoCopyWith(SettingsDto value, $Res Function(SettingsDto) _then) = _$SettingsDtoCopyWithImpl;
@useResult
$Res call({
 String user_id, bool reminder_on, bool budget_alert_on, bool tips_on
});




}
/// @nodoc
class _$SettingsDtoCopyWithImpl<$Res>
    implements $SettingsDtoCopyWith<$Res> {
  _$SettingsDtoCopyWithImpl(this._self, this._then);

  final SettingsDto _self;
  final $Res Function(SettingsDto) _then;

/// Create a copy of SettingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user_id = null,Object? reminder_on = null,Object? budget_alert_on = null,Object? tips_on = null,}) {
  return _then(_self.copyWith(
user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,reminder_on: null == reminder_on ? _self.reminder_on : reminder_on // ignore: cast_nullable_to_non_nullable
as bool,budget_alert_on: null == budget_alert_on ? _self.budget_alert_on : budget_alert_on // ignore: cast_nullable_to_non_nullable
as bool,tips_on: null == tips_on ? _self.tips_on : tips_on // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsDto].
extension SettingsDtoPatterns on SettingsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsDto value)  $default,){
final _that = this;
switch (_that) {
case _SettingsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsDto value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String user_id,  bool reminder_on,  bool budget_alert_on,  bool tips_on)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsDto() when $default != null:
return $default(_that.user_id,_that.reminder_on,_that.budget_alert_on,_that.tips_on);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String user_id,  bool reminder_on,  bool budget_alert_on,  bool tips_on)  $default,) {final _that = this;
switch (_that) {
case _SettingsDto():
return $default(_that.user_id,_that.reminder_on,_that.budget_alert_on,_that.tips_on);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String user_id,  bool reminder_on,  bool budget_alert_on,  bool tips_on)?  $default,) {final _that = this;
switch (_that) {
case _SettingsDto() when $default != null:
return $default(_that.user_id,_that.reminder_on,_that.budget_alert_on,_that.tips_on);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsDto implements SettingsDto {
  const _SettingsDto({required this.user_id, this.reminder_on = false, this.budget_alert_on = false, this.tips_on = false});
  factory _SettingsDto.fromJson(Map<String, dynamic> json) => _$SettingsDtoFromJson(json);

@override final  String user_id;
@override@JsonKey() final  bool reminder_on;
@override@JsonKey() final  bool budget_alert_on;
@override@JsonKey() final  bool tips_on;

/// Create a copy of SettingsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsDtoCopyWith<_SettingsDto> get copyWith => __$SettingsDtoCopyWithImpl<_SettingsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsDto&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.reminder_on, reminder_on) || other.reminder_on == reminder_on)&&(identical(other.budget_alert_on, budget_alert_on) || other.budget_alert_on == budget_alert_on)&&(identical(other.tips_on, tips_on) || other.tips_on == tips_on));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user_id,reminder_on,budget_alert_on,tips_on);

@override
String toString() {
  return 'SettingsDto(user_id: $user_id, reminder_on: $reminder_on, budget_alert_on: $budget_alert_on, tips_on: $tips_on)';
}


}

/// @nodoc
abstract mixin class _$SettingsDtoCopyWith<$Res> implements $SettingsDtoCopyWith<$Res> {
  factory _$SettingsDtoCopyWith(_SettingsDto value, $Res Function(_SettingsDto) _then) = __$SettingsDtoCopyWithImpl;
@override @useResult
$Res call({
 String user_id, bool reminder_on, bool budget_alert_on, bool tips_on
});




}
/// @nodoc
class __$SettingsDtoCopyWithImpl<$Res>
    implements _$SettingsDtoCopyWith<$Res> {
  __$SettingsDtoCopyWithImpl(this._self, this._then);

  final _SettingsDto _self;
  final $Res Function(_SettingsDto) _then;

/// Create a copy of SettingsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user_id = null,Object? reminder_on = null,Object? budget_alert_on = null,Object? tips_on = null,}) {
  return _then(_SettingsDto(
user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,reminder_on: null == reminder_on ? _self.reminder_on : reminder_on // ignore: cast_nullable_to_non_nullable
as bool,budget_alert_on: null == budget_alert_on ? _self.budget_alert_on : budget_alert_on // ignore: cast_nullable_to_non_nullable
as bool,tips_on: null == tips_on ? _self.tips_on : tips_on // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
