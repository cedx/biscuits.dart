part of biscuits;

/// Provides access to the HTTP cookies.
class Cookies extends MapBase<String, String> {

  /// The underlying HTML document.
  final dom.HtmlDocument _document;

  /// The handler of "changes" events.
  final StreamController<Map<String, SimpleChange>> _onChanges = StreamController<Map<String, SimpleChange>>.broadcast();

  /// Creates a new cookie service.
  Cookies({this.defaults, dom.HtmlDocument document}): _document = document ?? dom.document;

  /// The default cookie options.
  final CookieOptions defaults;

  /// The keys of the cookies associated with the current document.
  @override
  Iterable<String> get keys {
    var keys = _document.cookie.replaceAll(RegExp(r'((?:^|\s*;)[^=]+)(?=;|$)|^\s*|\s*(?:=[^;]*)?(?:\1|$)'), '');
    return keys.isNotEmpty ? keys.split(RegExp(r'\s*(?:=[^;]*)?;\s*')).map(Uri.decodeComponent) : <String>[];
  }

  /// The stream of "changes" events.
  Stream<Map<String, SimpleChange>> get onChanges => _onChanges.stream;

  /// Gets the value associated to the specified key.
  @override
  String operator [](Object key) {
    if (!containsKey(key)) return null;
    return null;

    /*
    var token = Uri.encodeComponent(key).replaceAll(RegExp(r'[-.+*]'), '\$&');
    var scanner = RegExp(`(?:(?:^|.*;)\\s*${token}\\s*\\=\\s*([^;]*).*$)|^.*$`);
    return Uri.decodeComponent(_document.cookie.replaceAll(scanner, r'$1')); // TODO replaceAllMapped
    */
  }

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) {
    var previousValue = this[key];
  }

  /// Removes all pairs from this configuration.
  @override
  void clear() {
    var changes = Map<String, SimpleChange>.fromIterable(keys, value: (key) => SimpleChange(previousValue: this[key]));
    keys.forEach(_removeItem);
    _onChanges.add(changes);
  }

  /// Gets a value indicating whether the current document has a cookie with the specified [key].
  @override
  bool containsKey(Object key) {
    /*
    var token = Uri.encodeComponent(key).replaceAll(RegExp(r'[-.+*]'), r'\$&');
    return RegExp(r'(?:^|;\s*)$token\s*\=').test(_document.cookie); // TODO check regex
    */
    return false;
  }

  /// Removes the specified [key] and its associated value from this configuration.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) => null;

  /// Converts this object to a map in JSON format.
  Map<String, String> toJson() => null;

  /// Returns a string representation of this object.
  @override
  String toString() => 'Cookies ${json.encode(this)}';

  /// Removes the value associated to the specified [key].
  void _removeItem(String key, {CookieOptions options}) {
    if (!containsKey(key)) return;

    /*
    var {domain, path} = _getOptions(options);
    var cookieOptions = CookieOptions(domain: domain, expires: 0, path: path);
    _document.cookie = '${Uri.encodeComponent(key)}=; $cookieOptions';
    */
  }
}
