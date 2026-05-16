import 'package:dotto/domain/menu_category.dart';
import 'package:dotto/domain/menu_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required DateTime date,
    required String name,
    required String imageUrl,
    required Category category,
    required List<Price> prices,
  }) = _MenuItem;
}
