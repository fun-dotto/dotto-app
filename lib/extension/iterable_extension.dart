import 'package:built_collection/built_collection.dart';

extension IterableToBuiltListOrNullExtension<E> on Iterable<E> {
  BuiltList<T>? mapToBuiltListOrNull<T>(T Function(E) convert) {
    if (isEmpty) {
      return null;
    }
    return BuiltList<T>(map(convert));
  }
}
