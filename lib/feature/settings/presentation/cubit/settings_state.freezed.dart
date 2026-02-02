// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 bool get isLoading; String? get errorMessage; AppSettings get settings; bool get hasAnyBudget; bool get shouldPromptSetBudget;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.hasAnyBudget, hasAnyBudget) || other.hasAnyBudget == hasAnyBudget)&&(identical(other.shouldPromptSetBudget, shouldPromptSetBudget) || other.shouldPromptSetBudget == shouldPromptSetBudget));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,settings,hasAnyBudget,shouldPromptSetBudget);

@override
String toString() {
  return 'SettingsState(isLoading: $isLoading, errorMessage: $errorMessage, settings: $settings, hasAnyBudget: $hasAnyBudget, shouldPromptSetBudget: $shouldPromptSetBudget)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, AppSettings settings, bool hasAnyBudget, bool shouldPromptSetBudget
});


$AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? settings = null,Object? hasAnyBudget = null,Object? shouldPromptSetBudget = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,hasAnyBudget: null == hasAnyBudget ? _self.hasAnyBudget : hasAnyBudget // ignore: cast_nullable_to_non_nullable
as bool,shouldPromptSetBudget: null == shouldPromptSetBudget ? _self.shouldPromptSetBudget : shouldPromptSetBudget // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  AppSettings settings,  bool hasAnyBudget,  bool shouldPromptSetBudget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.settings,_that.hasAnyBudget,_that.shouldPromptSetBudget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  AppSettings settings,  bool hasAnyBudget,  bool shouldPromptSetBudget)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.isLoading,_that.errorMessage,_that.settings,_that.hasAnyBudget,_that.shouldPromptSetBudget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorMessage,  AppSettings settings,  bool hasAnyBudget,  bool shouldPromptSetBudget)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.settings,_that.hasAnyBudget,_that.shouldPromptSetBudget);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({required this.isLoading, this.errorMessage, required this.settings, required this.hasAnyBudget, required this.shouldPromptSetBudget});
  

@override final  bool isLoading;
@override final  String? errorMessage;
@override final  AppSettings settings;
@override final  bool hasAnyBudget;
@override final  bool shouldPromptSetBudget;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.hasAnyBudget, hasAnyBudget) || other.hasAnyBudget == hasAnyBudget)&&(identical(other.shouldPromptSetBudget, shouldPromptSetBudget) || other.shouldPromptSetBudget == shouldPromptSetBudget));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,settings,hasAnyBudget,shouldPromptSetBudget);

@override
String toString() {
  return 'SettingsState(isLoading: $isLoading, errorMessage: $errorMessage, settings: $settings, hasAnyBudget: $hasAnyBudget, shouldPromptSetBudget: $shouldPromptSetBudget)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, AppSettings settings, bool hasAnyBudget, bool shouldPromptSetBudget
});


@override $AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? settings = null,Object? hasAnyBudget = null,Object? shouldPromptSetBudget = null,}) {
  return _then(_SettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,hasAnyBudget: null == hasAnyBudget ? _self.hasAnyBudget : hasAnyBudget // ignore: cast_nullable_to_non_nullable
as bool,shouldPromptSetBudget: null == shouldPromptSetBudget ? _self.shouldPromptSetBudget : shouldPromptSetBudget // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
