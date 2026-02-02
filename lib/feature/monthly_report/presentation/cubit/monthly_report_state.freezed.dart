// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyReportState {

 MonthlyReportTab get tab;/// Month currently selected by dropdown (drives Summary + Category)
 ReportMonth get selectedMonth;/// Year trend series (12 months)
 MonthlyTrend? get trend;/// Summary of selected month (income/expense/balance + top expenses)
 MonthlySummary? get summary;/// Category breakdown of selected month
 List<CategoryTotal> get expenseCategories; List<CategoryTotal> get incomeCategories;/// Loading flags
 bool get isLoadingTrend; bool get isLoadingMonthData;/// Error surface for UI
 String? get errorMessage;
/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportStateCopyWith<MonthlyReportState> get copyWith => _$MonthlyReportStateCopyWithImpl<MonthlyReportState>(this as MonthlyReportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReportState&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.selectedMonth, selectedMonth) || other.selectedMonth == selectedMonth)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.expenseCategories, expenseCategories)&&const DeepCollectionEquality().equals(other.incomeCategories, incomeCategories)&&(identical(other.isLoadingTrend, isLoadingTrend) || other.isLoadingTrend == isLoadingTrend)&&(identical(other.isLoadingMonthData, isLoadingMonthData) || other.isLoadingMonthData == isLoadingMonthData)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,tab,selectedMonth,trend,summary,const DeepCollectionEquality().hash(expenseCategories),const DeepCollectionEquality().hash(incomeCategories),isLoadingTrend,isLoadingMonthData,errorMessage);

@override
String toString() {
  return 'MonthlyReportState(tab: $tab, selectedMonth: $selectedMonth, trend: $trend, summary: $summary, expenseCategories: $expenseCategories, incomeCategories: $incomeCategories, isLoadingTrend: $isLoadingTrend, isLoadingMonthData: $isLoadingMonthData, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MonthlyReportStateCopyWith<$Res>  {
  factory $MonthlyReportStateCopyWith(MonthlyReportState value, $Res Function(MonthlyReportState) _then) = _$MonthlyReportStateCopyWithImpl;
@useResult
$Res call({
 MonthlyReportTab tab, ReportMonth selectedMonth, MonthlyTrend? trend, MonthlySummary? summary, List<CategoryTotal> expenseCategories, List<CategoryTotal> incomeCategories, bool isLoadingTrend, bool isLoadingMonthData, String? errorMessage
});


$MonthlyTrendCopyWith<$Res>? get trend;$MonthlySummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$MonthlyReportStateCopyWithImpl<$Res>
    implements $MonthlyReportStateCopyWith<$Res> {
  _$MonthlyReportStateCopyWithImpl(this._self, this._then);

  final MonthlyReportState _self;
  final $Res Function(MonthlyReportState) _then;

/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tab = null,Object? selectedMonth = null,Object? trend = freezed,Object? summary = freezed,Object? expenseCategories = null,Object? incomeCategories = null,Object? isLoadingTrend = null,Object? isLoadingMonthData = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MonthlyReportTab,selectedMonth: null == selectedMonth ? _self.selectedMonth : selectedMonth // ignore: cast_nullable_to_non_nullable
as ReportMonth,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as MonthlyTrend?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthlySummary?,expenseCategories: null == expenseCategories ? _self.expenseCategories : expenseCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryTotal>,incomeCategories: null == incomeCategories ? _self.incomeCategories : incomeCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryTotal>,isLoadingTrend: null == isLoadingTrend ? _self.isLoadingTrend : isLoadingTrend // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMonthData: null == isLoadingMonthData ? _self.isLoadingMonthData : isLoadingMonthData // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyTrendCopyWith<$Res>? get trend {
    if (_self.trend == null) {
    return null;
  }

  return $MonthlyTrendCopyWith<$Res>(_self.trend!, (value) {
    return _then(_self.copyWith(trend: value));
  });
}/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MonthlySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReportState].
extension MonthlyReportStatePatterns on MonthlyReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReportState value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReportState value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MonthlyReportTab tab,  ReportMonth selectedMonth,  MonthlyTrend? trend,  MonthlySummary? summary,  List<CategoryTotal> expenseCategories,  List<CategoryTotal> incomeCategories,  bool isLoadingTrend,  bool isLoadingMonthData,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReportState() when $default != null:
return $default(_that.tab,_that.selectedMonth,_that.trend,_that.summary,_that.expenseCategories,_that.incomeCategories,_that.isLoadingTrend,_that.isLoadingMonthData,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MonthlyReportTab tab,  ReportMonth selectedMonth,  MonthlyTrend? trend,  MonthlySummary? summary,  List<CategoryTotal> expenseCategories,  List<CategoryTotal> incomeCategories,  bool isLoadingTrend,  bool isLoadingMonthData,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportState():
return $default(_that.tab,_that.selectedMonth,_that.trend,_that.summary,_that.expenseCategories,_that.incomeCategories,_that.isLoadingTrend,_that.isLoadingMonthData,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MonthlyReportTab tab,  ReportMonth selectedMonth,  MonthlyTrend? trend,  MonthlySummary? summary,  List<CategoryTotal> expenseCategories,  List<CategoryTotal> incomeCategories,  bool isLoadingTrend,  bool isLoadingMonthData,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportState() when $default != null:
return $default(_that.tab,_that.selectedMonth,_that.trend,_that.summary,_that.expenseCategories,_that.incomeCategories,_that.isLoadingTrend,_that.isLoadingMonthData,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyReportState extends MonthlyReportState {
  const _MonthlyReportState({this.tab = MonthlyReportTab.monthly, required this.selectedMonth, this.trend, this.summary, final  List<CategoryTotal> expenseCategories = const <CategoryTotal>[], final  List<CategoryTotal> incomeCategories = const <CategoryTotal>[], this.isLoadingTrend = false, this.isLoadingMonthData = false, this.errorMessage}): _expenseCategories = expenseCategories,_incomeCategories = incomeCategories,super._();
  

@override@JsonKey() final  MonthlyReportTab tab;
/// Month currently selected by dropdown (drives Summary + Category)
@override final  ReportMonth selectedMonth;
/// Year trend series (12 months)
@override final  MonthlyTrend? trend;
/// Summary of selected month (income/expense/balance + top expenses)
@override final  MonthlySummary? summary;
/// Category breakdown of selected month
 final  List<CategoryTotal> _expenseCategories;
/// Category breakdown of selected month
@override@JsonKey() List<CategoryTotal> get expenseCategories {
  if (_expenseCategories is EqualUnmodifiableListView) return _expenseCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseCategories);
}

 final  List<CategoryTotal> _incomeCategories;
@override@JsonKey() List<CategoryTotal> get incomeCategories {
  if (_incomeCategories is EqualUnmodifiableListView) return _incomeCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeCategories);
}

/// Loading flags
@override@JsonKey() final  bool isLoadingTrend;
@override@JsonKey() final  bool isLoadingMonthData;
/// Error surface for UI
@override final  String? errorMessage;

/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportStateCopyWith<_MonthlyReportState> get copyWith => __$MonthlyReportStateCopyWithImpl<_MonthlyReportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReportState&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.selectedMonth, selectedMonth) || other.selectedMonth == selectedMonth)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._expenseCategories, _expenseCategories)&&const DeepCollectionEquality().equals(other._incomeCategories, _incomeCategories)&&(identical(other.isLoadingTrend, isLoadingTrend) || other.isLoadingTrend == isLoadingTrend)&&(identical(other.isLoadingMonthData, isLoadingMonthData) || other.isLoadingMonthData == isLoadingMonthData)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,tab,selectedMonth,trend,summary,const DeepCollectionEquality().hash(_expenseCategories),const DeepCollectionEquality().hash(_incomeCategories),isLoadingTrend,isLoadingMonthData,errorMessage);

@override
String toString() {
  return 'MonthlyReportState(tab: $tab, selectedMonth: $selectedMonth, trend: $trend, summary: $summary, expenseCategories: $expenseCategories, incomeCategories: $incomeCategories, isLoadingTrend: $isLoadingTrend, isLoadingMonthData: $isLoadingMonthData, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportStateCopyWith<$Res> implements $MonthlyReportStateCopyWith<$Res> {
  factory _$MonthlyReportStateCopyWith(_MonthlyReportState value, $Res Function(_MonthlyReportState) _then) = __$MonthlyReportStateCopyWithImpl;
@override @useResult
$Res call({
 MonthlyReportTab tab, ReportMonth selectedMonth, MonthlyTrend? trend, MonthlySummary? summary, List<CategoryTotal> expenseCategories, List<CategoryTotal> incomeCategories, bool isLoadingTrend, bool isLoadingMonthData, String? errorMessage
});


@override $MonthlyTrendCopyWith<$Res>? get trend;@override $MonthlySummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$MonthlyReportStateCopyWithImpl<$Res>
    implements _$MonthlyReportStateCopyWith<$Res> {
  __$MonthlyReportStateCopyWithImpl(this._self, this._then);

  final _MonthlyReportState _self;
  final $Res Function(_MonthlyReportState) _then;

/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? selectedMonth = null,Object? trend = freezed,Object? summary = freezed,Object? expenseCategories = null,Object? incomeCategories = null,Object? isLoadingTrend = null,Object? isLoadingMonthData = null,Object? errorMessage = freezed,}) {
  return _then(_MonthlyReportState(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MonthlyReportTab,selectedMonth: null == selectedMonth ? _self.selectedMonth : selectedMonth // ignore: cast_nullable_to_non_nullable
as ReportMonth,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as MonthlyTrend?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthlySummary?,expenseCategories: null == expenseCategories ? _self._expenseCategories : expenseCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryTotal>,incomeCategories: null == incomeCategories ? _self._incomeCategories : incomeCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryTotal>,isLoadingTrend: null == isLoadingTrend ? _self.isLoadingTrend : isLoadingTrend // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMonthData: null == isLoadingMonthData ? _self.isLoadingMonthData : isLoadingMonthData // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyTrendCopyWith<$Res>? get trend {
    if (_self.trend == null) {
    return null;
  }

  return $MonthlyTrendCopyWith<$Res>(_self.trend!, (value) {
    return _then(_self.copyWith(trend: value));
  });
}/// Create a copy of MonthlyReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MonthlySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
