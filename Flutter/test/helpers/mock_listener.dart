/// テスト用のリスナーインターフェース。
/// Mockitoの@GenerateMocksアノテーションで使用される。
abstract interface class Listener<T> {
  void call(T? previous, T next);
}
