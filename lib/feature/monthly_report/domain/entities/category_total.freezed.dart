// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_total.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryTotal {

 int get categoryId; String get name; String? get icon; Money get total;/// Percentage value in range 0..100
 double get percent;
/// Create a copy of CategoryTotal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryTotalCopyWith<CategoryTotal> get copyWith => _$CategoryTotalCopyWithImpl<CategoryTotal>(this as CategoryTotal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryTotal&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,icon,total,percent);

@override
String toString() {
  return 'CategoryTotal(categoryId: $categoryId, name: $name, icon: $icon, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $CategoryTotalCopyWith<$Res>  {
  factory $CategoryTotalCopyWith(CategoryTotal value, $Res Function(CategoryTotal) _then) = _$CategoryTotalCopyWithImpl;
@useResult
$Res call({
 int categoryId, String name, String? icon, Money total, double percent
});




}
/// @nodoc
class _$CategoryTotalCopyWithImpl<$Res>
    implements $CategoryTotalCopyWith<$Res> {
  _$CategoryTotalCopyWithImpl(this._self, this._then);

  final CategoryTotal _self;
  final $Res Function(CategoryTotal) _then;

/// Create a copy of CategoryTotal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? icon = freezed,Object? total = null,Object? percent = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryTotal].
extension CategoryTotalPatterns on CategoryTotal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryTotal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryTotal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryTotal value)  $default,){
final _that = this;
switch (_that) {
case _CategoryTotal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryTotal value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryTotal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  String name,  String? icon,  Money total,  double percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryTotal() when $default != null:
return $default(_that.categoryId,_that.name,_that.icon,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  String name,  String? icon,  Money total,  double percent)  $default,) {final _that = this;
switch (_that) {
case _CategoryTotal():
return $default(_that.categoryId,_that.name,_that.icon,_that.total,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  String name,  String? icon,  Money total,  double percent)?  $default,) {final _that = this;
switch (_that) {
case _CategoryTotal() when $default != null:
return $default(_that.categoryId,_that.name,_that.icon,_that.total,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryTotal implements CategoryTotal {
  const _CategoryTotal({required this.categoryId, required this.name, this.icon, required this.total, required this.percent});
  

@override final  int categoryId;
@override final  String name;
@override final  String? icon;
@override final  Money total;
/// Percentage value in range 0..100
@override final  double percent;

/// Create a copy of CategoryTotal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryTotalCopyWith<_CategoryTotal> get copyWith => __$CategoryTotalCopyWithImpl<_CategoryTotal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryTotal&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.total, total) || other.total == total)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,icon,total,percent);

@override
String toString() {
  return 'CategoryTotal(categoryId: $categoryId, name: $name, icon: $icon, total: $total, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$CategoryTotalCopyWith<$Res> implements $CategoryTotalCopyWith<$Res> {
  factory _$CategoryTotalCopyWith(_CategoryTotal value, $Res Function(_CategoryTotal) _then) = __$CategoryTotalCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String name, String? icon, Money total, double percent
});




}
/// @nodoc
class __$CategoryTotalCopyWithImpl<$Res>
    implements _$CategoryTotalCopyWith<$Res> {
  __$CategoryTotalCopyWithImpl(this._self, this._then);

  final _CategoryTotal _self;
  final $Res Function(_CategoryTotal) _then;

/// Create a copy of CategoryTotal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? icon = freezed,Object? total = null,Object? percent = null,}) {
  return _then(_CategoryTotal(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
