import 'package:dotto/foundation/async_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_async_states.freezed.dart';

@freezed
abstract class PageAsyncStates<T extends Object> with _$PageAsyncStates<T> {
  const factory PageAsyncStates({
    /// 全ての状態
    required List<AsyncEntity> states,

    /// 必須の状態
    required List<AsyncEntity> requiredStates,
  }) = _PageAsyncStates<T>;
}
