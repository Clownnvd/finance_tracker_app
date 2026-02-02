// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_trend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyTrend {

 int get year;/// Income totals grouped by month.
 Map<ReportMonth, Money> get incomeByMonth;/// Expense totals grouped by month.
 Map<ReportMonth, Money> get expenseByMonth;/// Currently selected month (for cards & dropdown).
 ReportMonth get selectedMonth;
/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyTrendCopyWith<MonthlyTrend> get copyWith => _$MonthlyTrendCopyWithImpl<MonthlyTrend>(this as MonthlyTrend, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyTrend&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.incomeByMonth, incomeByMonth)&&const DeepCollectionEquality().equals(other.expenseByMonth, expenseByMonth)&&(identical(other.selectedMonth, selectedMonth) || other.selectedMonth == selectedMonth));
}


@override
int get hashCode => Object.hash(runtimeType,year,const DeepCollectionEquality().hash(incomeByMonth),const DeepCollectionEquality().hash(expenseByMonth),selectedMonth);

@override
String toString() {
  return 'MonthlyTrend(year: $year, incomeByMonth: $incomeByMonth, expenseByMonth: $expenseByMonth, selectedMonth: $selectedMonth)';
}


}

/// @nodoc
abstract mixin class $MonthlyTrendCopyWith<$Res>  {
  factory $MonthlyTrendCopyWith(MonthlyTrend value, $Res Function(MonthlyTrend) _then) = _$MonthlyTrendCopyWithImpl;
@useResult
$Res call({
 int year, Map<ReportMonth, Money> incomeByMonth, Map<ReportMonth, Money> expenseByMonth, ReportMonth selectedMonth
});




}
/// @nodoc
class _$MonthlyTrendCopyWithImpl<$Res>
    implements $MonthlyTrendCopyWith<$Res> {
  _$MonthlyTrendCopyWithImpl(this._self, this._then);

  final MonthlyTrend _self;
  final $Res Function(MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? incomeByMonth = null,Object? expenseByMonth = null,Object? selectedMonth = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,incomeByMonth: null == incomeByMonth ? _self.incomeByMonth : incomeByMonth // ignore: cast_nullable_to_non_nullable
as Map<ReportMonth, Money>,expenseByMonth: null == expenseByMonth ? _self.expenseByMonth : expenseByMonth // ignore: cast_nullable_to_non_nullable
as Map<ReportMonth, Money>,selectedMonth: null == selectedMonth ? _self.selectedMonth : selectedMonth // ignore: cast_nullable_to_non_nullable
as ReportMonth,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyTrend].
extension MonthlyTrendPatterns on MonthlyTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyTrend value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyTrend value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  Map<ReportMonth, Money> incomeByMonth,  Map<ReportMonth, Money> expenseByMonth,  ReportMonth selectedMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.year,_that.incomeByMonth,_that.expenseByMonth,_that.selectedMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  Map<ReportMonth, Money> incomeByMonth,  Map<ReportMonth, Money> expenseByMonth,  ReportMonth selectedMonth)  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend():
return $default(_that.year,_that.incomeByMonth,_that.expenseByMonth,_that.selectedMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  Map<ReportMonth, Money> incomeByMonth,  Map<ReportMonth, Money> expenseByMonth,  ReportMonth selectedMonth)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.year,_that.incomeByMonth,_that.expenseByMonth,_that.selectedMonth);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyTrend extends MonthlyTrend {
  const _MonthlyTrend({required this.year, required final  Map<ReportMonth, Money> incomeByMonth, required final  Map<ReportMonth, Money> expenseByMonth, required this.selectedMonth}): _incomeByMonth = incomeByMonth,_expenseByMonth = expenseByMonth,super._();
  

@override final  int year;
/// Income totals grouped by month.
 final  Map<ReportMonth, Money> _incomeByMonth;
/// Income totals grouped by month.
@override Map<ReportMonth, Money> get incomeByMonth {
  if (_incomeByMonth is EqualUnmodifiableMapView) return _incomeByMonth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_incomeByMonth);
}

/// Expense totals grouped by month.
 final  Map<ReportMonth, Money> _expenseByMonth;
/// Expense totals grouped by month.
@override Map<ReportMonth, Money> get expenseByMonth {
  if (_expenseByMonth is EqualUnmodifiableMapView) return _expenseByMonth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_expenseByMonth);
}

/// Currently selected month (for cards & dropdown).
@override final  ReportMonth selectedMonth;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyTrendCopyWith<_MonthlyTrend> get copyWith => __$MonthlyTrendCopyWithImpl<_MonthlyTrend>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyTrend&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._incomeByMonth, _incomeByMonth)&&const DeepCollectionEquality().equals(other._expenseByMonth, _expenseByMonth)&&(identical(other.selectedMonth, selectedMonth) || other.selectedMonth == selectedMonth));
}


@override
int get hashCode => Object.hash(runtimeType,year,const DeepCollectionEquality().hash(_incomeByMonth),const DeepCollectionEquality().hash(_expenseByMonth),selectedMonth);

@override
String toString() {
  return 'MonthlyTrend(year: $year, incomeByMonth: $incomeByMonth, expenseByMonth: $expenseByMonth, selectedMonth: $selectedMonth)';
}


}

/// @nodoc
abstract mixin class _$MonthlyTrendCopyWith<$Res> implements $MonthlyTrendCopyWith<$Res> {
  factory _$MonthlyTrendCopyWith(_MonthlyTrend value, $Res Function(_MonthlyTrend) _then) = __$MonthlyTrendCopyWithImpl;
@override @useResult
$Res call({
 int year, Map<ReportMonth, Money> incomeByMonth, Map<ReportMonth, Money> expenseByMonth, ReportMonth selectedMonth
});




}
/// @nodoc
class __$MonthlyTrendCopyWithImpl<$Res>
    implements _$MonthlyTrendCopyWith<$Res> {
  __$MonthlyTrendCopyWithImpl(this._self, this._then);

  final _MonthlyTrend _self;
  final $Res Function(_MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? incomeByMonth = null,Object? expenseByMonth = null,Object? selectedMonth = null,}) {
  return _then(_MonthlyTrend(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,incomeByMonth: null == incomeByMonth ? _self._incomeByMonth : incomeByMonth // ignore: cast_nullable_to_non_nullable
as Map<ReportMonth, Money>,expenseByMonth: null == expenseByMonth ? _self._expenseByMonth : expenseByMonth // ignore: cast_nullable_to_non_nullable
as Map<ReportMonth, Money>,selectedMonth: null == selectedMonth ? _self.selectedMonth : selectedMonth // ignore: cast_nullable_to_non_nullable
as ReportMonth,
  ));
}


}

// dart format on
