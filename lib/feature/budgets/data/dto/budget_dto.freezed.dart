// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetDto {

 int get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'category_id') int get categoryId; double get amount; int get month;
/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetDtoCopyWith<BudgetDto> get copyWith => _$BudgetDtoCopyWithImpl<BudgetDto>(this as BudgetDto, _$identity);

  /// Serializes this BudgetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.month, month) || other.month == month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,amount,month);

@override
String toString() {
  return 'BudgetDto(id: $id, userId: $userId, categoryId: $categoryId, amount: $amount, month: $month)';
}


}

/// @nodoc
abstract mixin class $BudgetDtoCopyWith<$Res>  {
  factory $BudgetDtoCopyWith(BudgetDto value, $Res Function(BudgetDto) _then) = _$BudgetDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') int categoryId, double amount, int month
});




}
/// @nodoc
class _$BudgetDtoCopyWithImpl<$Res>
    implements $BudgetDtoCopyWith<$Res> {
  _$BudgetDtoCopyWithImpl(this._self, this._then);

  final BudgetDto _self;
  final $Res Function(BudgetDto) _then;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? amount = null,Object? month = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetDto].
extension BudgetDtoPatterns on BudgetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetDto value)  $default,){
final _that = this;
switch (_that) {
case _BudgetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetDto value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  int categoryId,  double amount,  int month)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.amount,_that.month);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  int categoryId,  double amount,  int month)  $default,) {final _that = this;
switch (_that) {
case _BudgetDto():
return $default(_that.id,_that.userId,_that.categoryId,_that.amount,_that.month);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  int categoryId,  double amount,  int month)?  $default,) {final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.amount,_that.month);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetDto implements BudgetDto {
  const _BudgetDto({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'category_id') required this.categoryId, required this.amount, required this.month});
  factory _BudgetDto.fromJson(Map<String, dynamic> json) => _$BudgetDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override final  double amount;
@override final  int month;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDtoCopyWith<_BudgetDto> get copyWith => __$BudgetDtoCopyWithImpl<_BudgetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.month, month) || other.month == month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,amount,month);

@override
String toString() {
  return 'BudgetDto(id: $id, userId: $userId, categoryId: $categoryId, amount: $amount, month: $month)';
}


}

/// @nodoc
abstract mixin class _$BudgetDtoCopyWith<$Res> implements $BudgetDtoCopyWith<$Res> {
  factory _$BudgetDtoCopyWith(_BudgetDto value, $Res Function(_BudgetDto) _then) = __$BudgetDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') int categoryId, double amount, int month
});




}
/// @nodoc
class __$BudgetDtoCopyWithImpl<$Res>
    implements _$BudgetDtoCopyWith<$Res> {
  __$BudgetDtoCopyWithImpl(this._self, this._then);

  final _BudgetDto _self;
  final $Res Function(_BudgetDto) _then;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? amount = null,Object? month = null,}) {
  return _then(_BudgetDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
