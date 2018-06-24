part of biscuits;

/// Provides access to the HTTP cookies.
class Cookies extends MapBase<String, String> {

  /// The handler of "changes" events.
  final StreamController<List<KeyValueChange>> _onChanges = StreamController<List<KeyValueChange>>.broadcast();

  /// The keys of this configuration.
  @override
  Iterable<String> get keys => _params.keys;

  /// The stream of "changes" events.
  Stream<List<KeyValueChange>> get onChanges => _onChanges.stream;

  /// Returns the value for the given [key] or `null` if [key] is not in this configuration.
  @override
  String operator [](Object key) => _params[key];

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => _params[key] = value;

  /// Removes all pairs from this configuration.
  @override
  void clear() => _params.clear();

  /// Removes the specified [key] and its associated value from this configuration.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) => _params.remove(key);

  /// Converts this object to a map in JSON format.
  Map<String, String> toJson() => _params;

  /// Returns a string representation of this object.
  @override
  String toString() => 'Cookies ${json.encode(this)}';
}
