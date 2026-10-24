/// Where a value came from. The UI must label [cache] data with its timestamp and must never
/// present it as live.
enum DataOrigin { network, cache }

class Fresh<T> {
  const Fresh(this.data, {required this.fetchedAt, required this.origin});

  final T data;
  final DateTime fetchedAt;
  final DataOrigin origin;

  bool get isCached => origin == DataOrigin.cache;

  Fresh<R> map<R>(R Function(T) f) => Fresh(f(data), fetchedAt: fetchedAt, origin: origin);
}
