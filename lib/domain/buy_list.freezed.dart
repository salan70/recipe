// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'buy_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OtherBuyListItem {
  String? get itemId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subTitle => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OtherBuyListItemCopyWith<OtherBuyListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtherBuyListItemCopyWith<$Res> {
  factory $OtherBuyListItemCopyWith(
          OtherBuyListItem value, $Res Function(OtherBuyListItem) then) =
      _$OtherBuyListItemCopyWithImpl<$Res>;
  $Res call(
      {String? itemId, DateTime? createdAt, String title, String subTitle});
}

/// @nodoc
class _$OtherBuyListItemCopyWithImpl<$Res>
    implements $OtherBuyListItemCopyWith<$Res> {
  _$OtherBuyListItemCopyWithImpl(this._value, this._then);

  final OtherBuyListItem _value;
  // ignore: unused_field
  final $Res Function(OtherBuyListItem) _then;

  @override
  $Res call({
    Object? itemId = freezed,
    Object? createdAt = freezed,
    Object? title = freezed,
    Object? subTitle = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: itemId == freezed
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: subTitle == freezed
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_OtherBuyListItemCopyWith<$Res>
    implements $OtherBuyListItemCopyWith<$Res> {
  factory _$$_OtherBuyListItemCopyWith(
          _$_OtherBuyListItem value, $Res Function(_$_OtherBuyListItem) then) =
      __$$_OtherBuyListItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? itemId, DateTime? createdAt, String title, String subTitle});
}

/// @nodoc
class __$$_OtherBuyListItemCopyWithImpl<$Res>
    extends _$OtherBuyListItemCopyWithImpl<$Res>
    implements _$$_OtherBuyListItemCopyWith<$Res> {
  __$$_OtherBuyListItemCopyWithImpl(
      _$_OtherBuyListItem _value, $Res Function(_$_OtherBuyListItem) _then)
      : super(_value, (v) => _then(v as _$_OtherBuyListItem));

  @override
  _$_OtherBuyListItem get _value => super._value as _$_OtherBuyListItem;

  @override
  $Res call({
    Object? itemId = freezed,
    Object? createdAt = freezed,
    Object? title = freezed,
    Object? subTitle = freezed,
  }) {
    return _then(_$_OtherBuyListItem(
      itemId: itemId == freezed
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: subTitle == freezed
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_OtherBuyListItem
    with DiagnosticableTreeMixin
    implements _OtherBuyListItem {
  const _$_OtherBuyListItem(
      {this.itemId,
      this.createdAt,
      required this.title,
      required this.subTitle});

  @override
  final String? itemId;
  @override
  final DateTime? createdAt;
  @override
  final String title;
  @override
  final String subTitle;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtherBuyListItem(itemId: $itemId, createdAt: $createdAt, title: $title, subTitle: $subTitle)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtherBuyListItem'))
      ..add(DiagnosticsProperty('itemId', itemId))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subTitle', subTitle));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OtherBuyListItem &&
            const DeepCollectionEquality().equals(other.itemId, itemId) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.subTitle, subTitle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(itemId),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(subTitle));

  @JsonKey(ignore: true)
  @override
  _$$_OtherBuyListItemCopyWith<_$_OtherBuyListItem> get copyWith =>
      __$$_OtherBuyListItemCopyWithImpl<_$_OtherBuyListItem>(this, _$identity);
}

abstract class _OtherBuyListItem implements OtherBuyListItem {
  const factory _OtherBuyListItem(
      {final String? itemId,
      final DateTime? createdAt,
      required final String title,
      required final String subTitle}) = _$_OtherBuyListItem;

  @override
  String? get itemId => throw _privateConstructorUsedError;
  @override
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get subTitle => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_OtherBuyListItemCopyWith<_$_OtherBuyListItem> get copyWith =>
      throw _privateConstructorUsedError;
}
