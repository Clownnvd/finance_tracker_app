// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardSummaryModel {

 double get income; double get expenses;
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryModelCopyWith<DashboardSummaryModel> get copyWith => _$DashboardSummaryModelCopyWithImpl<DashboardSummaryModel>(this as DashboardSummaryModel, _$identity);

  /// Serializes this DashboardSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummaryModel&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expenses);

@override
String toString() {
  return 'DashboardSummaryModel(income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryModelCopyWith<$Res>  {
  factory $DashboardSummaryModelCopyWith(DashboardSummaryModel value, $Res Function(DashboardSummaryModel) _then) = _$DashboardSummaryModelCopyWithImpl;
@useResult
$Res call({
 double income, double expenses
});




}
/// @nodoc
class _$DashboardSummaryModelCopyWithImpl<$Res>
    implements $DashboardSummaryModelCopyWith<$Res> {
  _$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final DashboardSummaryModel _self;
  final $Res Function(DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? expenses = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummaryModel].
extension DashboardSummaryModelPatterns on DashboardSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double income,  double expenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double income,  double expenses)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel():
return $default(_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double income,  double expenses)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.income,_that.expenses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummaryModel implements DashboardSummaryModel {
  const _DashboardSummaryModel({required this.income, required this.expenses});
  factory _DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

@override final  double income;
@override final  double expenses;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryModelCopyWith<_DashboardSummaryModel> get copyWith => __$DashboardSummaryModelCopyWithImpl<_DashboardSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummaryModel&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expenses);

@override
String toString() {
  return 'DashboardSummaryModel(income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryModelCopyWith<$Res> implements $DashboardSummaryModelCopyWith<$Res> {
  factory _$DashboardSummaryModelCopyWith(_DashboardSummaryModel value, $Res Function(_DashboardSummaryModel) _then) = __$DashboardSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 double income, double expenses
});




}
/// @nodoc
class __$DashboardSummaryModelCopyWithImpl<$Res>
    implements _$DashboardSummaryModelCopyWith<$Res> {
  __$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final _DashboardSummaryModel _self;
  final $Res Function(_DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? expenses = null,}) {
  return _then(_DashboardSummaryModel(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardTransactionModel {

 int get id; String get title; String get icon; DateTime get date; double get amount; bool get isIncome; String? get note; int? get categoryId;
/// Create a copy of DashboardTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTransactionModelCopyWith<DashboardTransactionModel> get copyWith => _$DashboardTransactionModelCopyWithImpl<DashboardTransactionModel>(this as DashboardTransactionModel, _$identity);

  /// Serializes this DashboardTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.note, note) || other.note == note)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,icon,date,amount,isIncome,note,categoryId);

@override
String toString() {
  return 'DashboardTransactionModel(id: $id, title: $title, icon: $icon, date: $date, amount: $amount, isIncome: $isIncome, note: $note, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $DashboardTransactionModelCopyWith<$Res>  {
  factory $DashboardTransactionModelCopyWith(DashboardTransactionModel value, $Res Function(DashboardTransactionModel) _then) = _$DashboardTransactionModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String icon, DateTime date, double amount, bool isIncome, String? note, int? categoryId
});




}
/// @nodoc
class _$DashboardTransactionModelCopyWithImpl<$Res>
    implements $DashboardTransactionModelCopyWith<$Res> {
  _$DashboardTransactionModelCopyWithImpl(this._self, this._then);

  final DashboardTransactionModel _self;
  final $Res Function(DashboardTransactionModel) _then;

/// Create a copy of DashboardTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? icon = null,Object? date = null,Object? amount = null,Object? isIncome = null,Object? note = freezed,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTransactionModel].
extension DashboardTransactionModelPatterns on DashboardTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String icon,  DateTime date,  double amount,  bool isIncome,  String? note,  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTransactionModel() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.date,_that.amount,_that.isIncome,_that.note,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String icon,  DateTime date,  double amount,  bool isIncome,  String? note,  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _DashboardTransactionModel():
return $default(_that.id,_that.title,_that.icon,_that.date,_that.amount,_that.isIncome,_that.note,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String icon,  DateTime date,  double amount,  bool isIncome,  String? note,  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTransactionModel() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.date,_that.amount,_that.isIncome,_that.note,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTransactionModel implements DashboardTransactionModel {
  const _DashboardTransactionModel({required this.id, required this.title, required this.icon, required this.date, required this.amount, required this.isIncome, this.note, this.categoryId});
  factory _DashboardTransactionModel.fromJson(Map<String, dynamic> json) => _$DashboardTransactionModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String icon;
@override final  DateTime date;
@override final  double amount;
@override final  bool isIncome;
@override final  String? note;
@override final  int? categoryId;

/// Create a copy of DashboardTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTransactionModelCopyWith<_DashboardTransactionModel> get copyWith => __$DashboardTransactionModelCopyWithImpl<_DashboardTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.note, note) || other.note == note)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,icon,date,amount,isIncome,note,categoryId);

@override
String toString() {
  return 'DashboardTransactionModel(id: $id, title: $title, icon: $icon, date: $date, amount: $amount, isIncome: $isIncome, note: $note, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$DashboardTransactionModelCopyWith<$Res> implements $DashboardTransactionModelCopyWith<$Res> {
  factory _$DashboardTransactionModelCopyWith(_DashboardTransactionModel value, $Res Function(_DashboardTransactionModel) _then) = __$DashboardTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String icon, DateTime date, double amount, bool isIncome, String? note, int? categoryId
});




}
/// @nodoc
class __$DashboardTransactionModelCopyWithImpl<$Res>
    implements _$DashboardTransactionModelCopyWith<$Res> {
  __$DashboardTransactionModelCopyWithImpl(this._self, this._then);

  final _DashboardTransactionModel _self;
  final $Res Function(_DashboardTransactionModel) _then;

/// Create a copy of DashboardTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? icon = null,Object? date = null,Object? amount = null,Object? isIncome = null,Object? note = freezed,Object? categoryId = freezed,}) {
  return _then(_DashboardTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DashboardCategoryBreakdownModel {

@JsonKey(name: 'category_id') int get categoryId; String get name; double get total; double get percent;
/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCategoryBreakdownModelCopyWith<DashboardCategoryBreakdownModel> get copyWith => _$DashboardCategoryBreakdownModelCopyWithImpl<DashboardCategoryBreakdownModel>(this as DashboardCategoryBreakdownModel, _$identity);

  /// Serializes this DashboardCategoryBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCategoryBreakdownModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,name,total,percent);

@override
String toString() {
  return 'DashboardCategoryBreakdownModel(categoryId: $categoryId, name: $name, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $DashboardCategoryBreakdownModelCopyWith<$Res>  {
  factory $DashboardCategoryBreakdownModelCopyWith(DashboardCategoryBreakdownModel value, $Res Function(DashboardCategoryBreakdownModel) _then) = _$DashboardCategoryBreakdownModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId, String name, double total, double percent
});




}
/// @nodoc
class _$DashboardCategoryBreakdownModelCopyWithImpl<$Res>
    implements $DashboardCategoryBreakdownModelCopyWith<$Res> {
  _$DashboardCategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final DashboardCategoryBreakdownModel _self;
  final $Res Function(DashboardCategoryBreakdownModel) _then;

/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? total = null,Object? percent = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardCategoryBreakdownModel].
extension DashboardCategoryBreakdownModelPatterns on DashboardCategoryBreakdownModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCategoryBreakdownModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId,  String name,  double total,  double percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
return $default(_that.categoryId,_that.name,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId,  String name,  double total,  double percent)  $default,) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel():
return $default(_that.categoryId,_that.name,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId,  String name,  double total,  double percent)?  $default,) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
return $default(_that.categoryId,_that.name,_that.total,_that.percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCategoryBreakdownModel implements DashboardCategoryBreakdownModel {
  const _DashboardCategoryBreakdownModel({@JsonKey(name: 'category_id') required this.categoryId, required this.name, required this.total, required this.percent});
  factory _DashboardCategoryBreakdownModel.fromJson(Map<String, dynamic> json) => _$DashboardCategoryBreakdownModelFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override final  String name;
@override final  double total;
@override final  double percent;

/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCategoryBreakdownModelCopyWith<_DashboardCategoryBreakdownModel> get copyWith => __$DashboardCategoryBreakdownModelCopyWithImpl<_DashboardCategoryBreakdownModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCategoryBreakdownModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCategoryBreakdownModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,name,total,percent);

@override
String toString() {
  return 'DashboardCategoryBreakdownModel(categoryId: $categoryId, name: $name, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$DashboardCategoryBreakdownModelCopyWith<$Res> implements $DashboardCategoryBreakdownModelCopyWith<$Res> {
  factory _$DashboardCategoryBreakdownModelCopyWith(_DashboardCategoryBreakdownModel value, $Res Function(_DashboardCategoryBreakdownModel) _then) = __$DashboardCategoryBreakdownModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId, String name, double total, double percent
});




}
/// @nodoc
class __$DashboardCategoryBreakdownModelCopyWithImpl<$Res>
    implements _$DashboardCategoryBreakdownModelCopyWith<$Res> {
  __$DashboardCategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final _DashboardCategoryBreakdownModel _self;
  final $Res Function(_DashboardCategoryBreakdownModel) _then;

/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? total = null,Object? percent = null,}) {
  return _then(_DashboardCategoryBreakdownModel(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
