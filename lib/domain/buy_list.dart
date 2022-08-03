import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'buy_list.freezed.dart';

@freezed
class OtherBuyListItem with _$OtherBuyListItem {
  const factory OtherBuyListItem({
    String? itemId,
    DateTime? createdAt,
    required String title,
    required String subTitle,
  }) = _OtherBuyListItem;
}
