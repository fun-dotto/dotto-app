import 'package:dotto/domain/menu_size.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_price.freezed.dart';

@freezed
abstract class Price with _$Price {
  const factory Price({required Size size, required int price}) = _Price;
}
