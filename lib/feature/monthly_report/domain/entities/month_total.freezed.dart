// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_total.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthTotal {

 ReportMonth get month; Money get amount; MonthTotalType get type;
/// Create a copy of MonthTotal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthTotalCopyWith<MonthTotal> get copyWith => _$MonthTotalCopyWithImpl<MonthTotal>(this as MonthTotal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthTotal&&(identical(other.month, month) || other.month == month)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,month,amount,type);

@override
String toString() {
  return 'MonthTotal(month: $month, amount: $amount, type: $type)';
}


}

/// @nodoc
abstract mixin class $MonthTotalCopyWith<$Res>  {
  factory $MonthTotalCopyWith(MonthTotal value, $Res Function(MonthTotal) _then) = _$MonthTotalCopyWithImpl;
@useResult
$Res call({
 ReportMonth month, Money amount, MonthTotalType type
});




}
/// @nodoc
class _$MonthTotalCopyWithImpl<$Res>
    implements $MonthTotalCopyWith<$Res> {
  _$MonthTotalCopyWithImpl(this._self, this._then);

  final MonthTotal _self;
  final $Res Function(MonthTotal) _then;

/// Create a copy of MonthTotal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? amount = null,Object? type = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as ReportMonth,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MonthTotalType,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthTotal].
extension MonthTotalPatterns on MonthTotal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthTotal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthTotal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthTotal value)  $default,){
final _that = this;
switch (_that) {
case _MonthTotal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthTotal value)?  $default,){
final _that = this;
switch (_that) {
case _MonthTotal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportMonth month,  Money amount,  MonthTotalType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthTotal() when $default != null:
return $default(_that.month,_that.amount,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportMonth month,  Money amount,  MonthTotalType type)  $default,) {final _that = this;
switch (_that) {
case _MonthTotal():
return $default(_that.month,_that.amount,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportMonth month,  Money amount,  MonthTotalType type)?  $default,) {final _that = this;
switch (_that) {
case _MonthTotal() when $default != null:
return $default(_that.month,_that.amount,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _MonthTotal implements MonthTotal {
  const _MonthTotal({required this.month, required this.amount, required this.type});
  

@override final  ReportMonth month;
@override final  Money amount;
@override final  MonthTotalType type;

/// Create a copy of MonthTotal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthTotalCopyWith<_MonthTotal> get copyWith => __$MonthTotalCopyWithImpl<_MonthTotal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthTotal&&(identical(other.month, month) || other.month == month)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,month,amount,type);

@override
String toString() {
  return 'MonthTotal(month: $month, amount: $amount, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MonthTotalCopyWith<$Res> implements $MonthTotalCopyWith<$Res> {
  factory _$MonthTotalCopyWith(_MonthTotal value, $Res Function(_MonthTotal) _then) = __$MonthTotalCopyWithImpl;
@override @useResult
$Res call({
 ReportMonth month, Money amount, MonthTotalType type
});




}
/// @nodoc
class __$MonthTotalCopyWithImpl<$Res>
    implements _$MonthTotalCopyWith<$Res> {
  __$MonthTotalCopyWithImpl(this._self, this._then);

  final _MonthTotal _self;
  final $Res Function(_MonthTotal) _then;

/// Create a copy of MonthTotal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? amount = null,Object? type = null,}) {
  return _then(_MonthTotal(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as ReportMonth,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MonthTotalType,
  ));
}


}

// dart format on
