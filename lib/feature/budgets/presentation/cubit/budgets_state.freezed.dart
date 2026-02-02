// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budgets_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetsState {

 bool get isLoading; bool get isSaving; String? get errorMessage; List<Budget> get budgets;// UI helper
 Budget? get lastCreatedOrUpdated; int? get deletingBudgetId;
/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetsStateCopyWith<BudgetsState> get copyWith => _$BudgetsStateCopyWithImpl<BudgetsState>(this as BudgetsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.budgets, budgets)&&(identical(other.lastCreatedOrUpdated, lastCreatedOrUpdated) || other.lastCreatedOrUpdated == lastCreatedOrUpdated)&&(identical(other.deletingBudgetId, deletingBudgetId) || other.deletingBudgetId == deletingBudgetId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSaving,errorMessage,const DeepCollectionEquality().hash(budgets),lastCreatedOrUpdated,deletingBudgetId);

@override
String toString() {
  return 'BudgetsState(isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage, budgets: $budgets, lastCreatedOrUpdated: $lastCreatedOrUpdated, deletingBudgetId: $deletingBudgetId)';
}


}

/// @nodoc
abstract mixin class $BudgetsStateCopyWith<$Res>  {
  factory $BudgetsStateCopyWith(BudgetsState value, $Res Function(BudgetsState) _then) = _$BudgetsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSaving, String? errorMessage, List<Budget> budgets, Budget? lastCreatedOrUpdated, int? deletingBudgetId
});


$BudgetCopyWith<$Res>? get lastCreatedOrUpdated;

}
/// @nodoc
class _$BudgetsStateCopyWithImpl<$Res>
    implements $BudgetsStateCopyWith<$Res> {
  _$BudgetsStateCopyWithImpl(this._self, this._then);

  final BudgetsState _self;
  final $Res Function(BudgetsState) _then;

/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSaving = null,Object? errorMessage = freezed,Object? budgets = null,Object? lastCreatedOrUpdated = freezed,Object? deletingBudgetId = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,lastCreatedOrUpdated: freezed == lastCreatedOrUpdated ? _self.lastCreatedOrUpdated : lastCreatedOrUpdated // ignore: cast_nullable_to_non_nullable
as Budget?,deletingBudgetId: freezed == deletingBudgetId ? _self.deletingBudgetId : deletingBudgetId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get lastCreatedOrUpdated {
    if (_self.lastCreatedOrUpdated == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.lastCreatedOrUpdated!, (value) {
    return _then(_self.copyWith(lastCreatedOrUpdated: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetsState].
extension BudgetsStatePatterns on BudgetsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetsState value)  $default,){
final _that = this;
switch (_that) {
case _BudgetsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetsState value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  String? errorMessage,  List<Budget> budgets,  Budget? lastCreatedOrUpdated,  int? deletingBudgetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.errorMessage,_that.budgets,_that.lastCreatedOrUpdated,_that.deletingBudgetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  String? errorMessage,  List<Budget> budgets,  Budget? lastCreatedOrUpdated,  int? deletingBudgetId)  $default,) {final _that = this;
switch (_that) {
case _BudgetsState():
return $default(_that.isLoading,_that.isSaving,_that.errorMessage,_that.budgets,_that.lastCreatedOrUpdated,_that.deletingBudgetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSaving,  String? errorMessage,  List<Budget> budgets,  Budget? lastCreatedOrUpdated,  int? deletingBudgetId)?  $default,) {final _that = this;
switch (_that) {
case _BudgetsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.errorMessage,_that.budgets,_that.lastCreatedOrUpdated,_that.deletingBudgetId);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetsState implements BudgetsState {
  const _BudgetsState({required this.isLoading, required this.isSaving, this.errorMessage, required final  List<Budget> budgets, this.lastCreatedOrUpdated, this.deletingBudgetId}): _budgets = budgets;
  

@override final  bool isLoading;
@override final  bool isSaving;
@override final  String? errorMessage;
 final  List<Budget> _budgets;
@override List<Budget> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

// UI helper
@override final  Budget? lastCreatedOrUpdated;
@override final  int? deletingBudgetId;

/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetsStateCopyWith<_BudgetsState> get copyWith => __$BudgetsStateCopyWithImpl<_BudgetsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&(identical(other.lastCreatedOrUpdated, lastCreatedOrUpdated) || other.lastCreatedOrUpdated == lastCreatedOrUpdated)&&(identical(other.deletingBudgetId, deletingBudgetId) || other.deletingBudgetId == deletingBudgetId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSaving,errorMessage,const DeepCollectionEquality().hash(_budgets),lastCreatedOrUpdated,deletingBudgetId);

@override
String toString() {
  return 'BudgetsState(isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage, budgets: $budgets, lastCreatedOrUpdated: $lastCreatedOrUpdated, deletingBudgetId: $deletingBudgetId)';
}


}

/// @nodoc
abstract mixin class _$BudgetsStateCopyWith<$Res> implements $BudgetsStateCopyWith<$Res> {
  factory _$BudgetsStateCopyWith(_BudgetsState value, $Res Function(_BudgetsState) _then) = __$BudgetsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSaving, String? errorMessage, List<Budget> budgets, Budget? lastCreatedOrUpdated, int? deletingBudgetId
});


@override $BudgetCopyWith<$Res>? get lastCreatedOrUpdated;

}
/// @nodoc
class __$BudgetsStateCopyWithImpl<$Res>
    implements _$BudgetsStateCopyWith<$Res> {
  __$BudgetsStateCopyWithImpl(this._self, this._then);

  final _BudgetsState _self;
  final $Res Function(_BudgetsState) _then;

/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSaving = null,Object? errorMessage = freezed,Object? budgets = null,Object? lastCreatedOrUpdated = freezed,Object? deletingBudgetId = freezed,}) {
  return _then(_BudgetsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,lastCreatedOrUpdated: freezed == lastCreatedOrUpdated ? _self.lastCreatedOrUpdated : lastCreatedOrUpdated // ignore: cast_nullable_to_non_nullable
as Budget?,deletingBudgetId: freezed == deletingBudgetId ? _self.deletingBudgetId : deletingBudgetId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BudgetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get lastCreatedOrUpdated {
    if (_self.lastCreatedOrUpdated == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.lastCreatedOrUpdated!, (value) {
    return _then(_self.copyWith(lastCreatedOrUpdated: value));
  });
}
}

// dart format on
