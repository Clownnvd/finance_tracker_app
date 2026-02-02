// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TopExpense {

 int get transactionId; int get categoryId; String get categoryName; String? get categoryIcon; Money get amount;
/// Create a copy of TopExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopExpenseCopyWith<TopExpense> get copyWith => _$TopExpenseCopyWithImpl<TopExpense>(this as TopExpense, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopExpense&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,categoryId,categoryName,categoryIcon,amount);

@override
String toString() {
  return 'TopExpense(transactionId: $transactionId, categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $TopExpenseCopyWith<$Res>  {
  factory $TopExpenseCopyWith(TopExpense value, $Res Function(TopExpense) _then) = _$TopExpenseCopyWithImpl;
@useResult
$Res call({
 int transactionId, int categoryId, String categoryName, String? categoryIcon, Money amount
});




}
/// @nodoc
class _$TopExpenseCopyWithImpl<$Res>
    implements $TopExpenseCopyWith<$Res> {
  _$TopExpenseCopyWithImpl(this._self, this._then);

  final TopExpense _self;
  final $Res Function(TopExpense) _then;

/// Create a copy of TopExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? categoryId = null,Object? categoryName = null,Object? categoryIcon = freezed,Object? amount = null,}) {
  return _then(_self.copyWith(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [TopExpense].
extension TopExpensePatterns on TopExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopExpense value)  $default,){
final _that = this;
switch (_that) {
case _TopExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopExpense value)?  $default,){
final _that = this;
switch (_that) {
case _TopExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transactionId,  int categoryId,  String categoryName,  String? categoryIcon,  Money amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopExpense() when $default != null:
return $default(_that.transactionId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transactionId,  int categoryId,  String categoryName,  String? categoryIcon,  Money amount)  $default,) {final _that = this;
switch (_that) {
case _TopExpense():
return $default(_that.transactionId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transactionId,  int categoryId,  String categoryName,  String? categoryIcon,  Money amount)?  $default,) {final _that = this;
switch (_that) {
case _TopExpense() when $default != null:
return $default(_that.transactionId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _TopExpense implements TopExpense {
  const _TopExpense({required this.transactionId, required this.categoryId, required this.categoryName, this.categoryIcon, required this.amount});
  

@override final  int transactionId;
@override final  int categoryId;
@override final  String categoryName;
@override final  String? categoryIcon;
@override final  Money amount;

/// Create a copy of TopExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopExpenseCopyWith<_TopExpense> get copyWith => __$TopExpenseCopyWithImpl<_TopExpense>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopExpense&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,categoryId,categoryName,categoryIcon,amount);

@override
String toString() {
  return 'TopExpense(transactionId: $transactionId, categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$TopExpenseCopyWith<$Res> implements $TopExpenseCopyWith<$Res> {
  factory _$TopExpenseCopyWith(_TopExpense value, $Res Function(_TopExpense) _then) = __$TopExpenseCopyWithImpl;
@override @useResult
$Res call({
 int transactionId, int categoryId, String categoryName, String? categoryIcon, Money amount
});




}
/// @nodoc
class __$TopExpenseCopyWithImpl<$Res>
    implements _$TopExpenseCopyWith<$Res> {
  __$TopExpenseCopyWithImpl(this._self, this._then);

  final _TopExpense _self;
  final $Res Function(_TopExpense) _then;

/// Create a copy of TopExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? categoryId = null,Object? categoryName = null,Object? categoryIcon = freezed,Object? amount = null,}) {
  return _then(_TopExpense(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
