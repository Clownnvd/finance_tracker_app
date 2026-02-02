// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlySummary {

 ReportMonth get month; Money get income; Money get expense; Money get balance; List<TopExpense> get topExpenses;
/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<MonthlySummary> get copyWith => _$MonthlySummaryCopyWithImpl<MonthlySummary>(this as MonthlySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlySummary&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.topExpenses, topExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,balance,const DeepCollectionEquality().hash(topExpenses));

@override
String toString() {
  return 'MonthlySummary(month: $month, income: $income, expense: $expense, balance: $balance, topExpenses: $topExpenses)';
}


}

/// @nodoc
abstract mixin class $MonthlySummaryCopyWith<$Res>  {
  factory $MonthlySummaryCopyWith(MonthlySummary value, $Res Function(MonthlySummary) _then) = _$MonthlySummaryCopyWithImpl;
@useResult
$Res call({
 ReportMonth month, Money income, Money expense, Money balance, List<TopExpense> topExpenses
});




}
/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._self, this._then);

  final MonthlySummary _self;
  final $Res Function(MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? balance = null,Object? topExpenses = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as ReportMonth,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as Money,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Money,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,topExpenses: null == topExpenses ? _self.topExpenses : topExpenses // ignore: cast_nullable_to_non_nullable
as List<TopExpense>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlySummary].
extension MonthlySummaryPatterns on MonthlySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlySummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlySummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportMonth month,  Money income,  Money expense,  Money balance,  List<TopExpense> topExpenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.balance,_that.topExpenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportMonth month,  Money income,  Money expense,  Money balance,  List<TopExpense> topExpenses)  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary():
return $default(_that.month,_that.income,_that.expense,_that.balance,_that.topExpenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportMonth month,  Money income,  Money expense,  Money balance,  List<TopExpense> topExpenses)?  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.balance,_that.topExpenses);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlySummary implements MonthlySummary {
  const _MonthlySummary({required this.month, required this.income, required this.expense, required this.balance, required final  List<TopExpense> topExpenses}): _topExpenses = topExpenses;
  

@override final  ReportMonth month;
@override final  Money income;
@override final  Money expense;
@override final  Money balance;
 final  List<TopExpense> _topExpenses;
@override List<TopExpense> get topExpenses {
  if (_topExpenses is EqualUnmodifiableListView) return _topExpenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topExpenses);
}


/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlySummaryCopyWith<_MonthlySummary> get copyWith => __$MonthlySummaryCopyWithImpl<_MonthlySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlySummary&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._topExpenses, _topExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,balance,const DeepCollectionEquality().hash(_topExpenses));

@override
String toString() {
  return 'MonthlySummary(month: $month, income: $income, expense: $expense, balance: $balance, topExpenses: $topExpenses)';
}


}

/// @nodoc
abstract mixin class _$MonthlySummaryCopyWith<$Res> implements $MonthlySummaryCopyWith<$Res> {
  factory _$MonthlySummaryCopyWith(_MonthlySummary value, $Res Function(_MonthlySummary) _then) = __$MonthlySummaryCopyWithImpl;
@override @useResult
$Res call({
 ReportMonth month, Money income, Money expense, Money balance, List<TopExpense> topExpenses
});




}
/// @nodoc
class __$MonthlySummaryCopyWithImpl<$Res>
    implements _$MonthlySummaryCopyWith<$Res> {
  __$MonthlySummaryCopyWithImpl(this._self, this._then);

  final _MonthlySummary _self;
  final $Res Function(_MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? balance = null,Object? topExpenses = null,}) {
  return _then(_MonthlySummary(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as ReportMonth,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as Money,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Money,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,topExpenses: null == topExpenses ? _self._topExpenses : topExpenses // ignore: cast_nullable_to_non_nullable
as List<TopExpense>,
  ));
}


}

// dart format on
