part of '../biscuits.dart';

/// Provides access to the HTTP cookies.
/// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
class Cookies extends Object with MapMixin<String, String> {

  /// The underlying HTML document.
  final dom.HtmlDocument _document;

  /// The handler of "changes" events.
  final StreamController<Map<String, SimpleChange>> _onChanges = StreamController<Map<String, SimpleChange>>.broadcast();

  /// Creates a new cookie service.
  Cookies({CookieOptions defaults, dom.HtmlDocument document}):
    defaults = defaults ?? CookieOptions(),
    _document = document ?? dom.document;

  /// The default cookie options.
  final CookieOptions defaults;

  /// The keys of the cookies associated with the current document.
  @override
  Iterable<String> get keys {
    final keys = _document.cookie.replaceAll(RegExp(r'((?:^|\s*;)[^=]+)(?=;|$)|^\s*|\s*(?:=[^;]*)?(?:\1|$)'), '');
    return keys.isNotEmpty ? keys.split(RegExp(r'\s*(?:=[^;]*)?;\s*')).map(Uri.decodeComponent) : <String>[];
  }

  /// The stream of "changes" events.
  Stream<Map<String, SimpleChange>> get onChanges => _onChanges.stream;

  /// Gets the value associated to the specified [key].
  @override
  String operator [](Object key) {
    if (!containsKey(key)) return null;

    try {
      final token = Uri.encodeComponent(key).replaceAll(RegExp('[-.+*]'), r'\$&');
      final scanner = RegExp('(?:(?:^|.*;)\\s*$token\\s*\\=\\s*([^;]*).*\$)|^.*\$');
      return Uri.decodeComponent(_document.cookie.replaceAllMapped(scanner, (match) => match[1]));
    }

    on Exception {
      return null;
    }
  }

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => set(key, value);

  /// Removes all cookies associated with the current document.
  @override
  void clear() {
    final changes = <String, SimpleChange>{};
    for (final key in keys) {
      changes[key] = SimpleChange(previousValue: this[key]);
      _removeItem(key);
    }

    _onChanges.add(changes);
  }

  /// Gets a value indicating whether the current document has a cookie with the specified [key].
  @override
  bool containsKey(Object key) {
    final token = Uri.encodeComponent(key).replaceAll(RegExp(r'[-.+*]'), r'\$&');
    return RegExp('(?:^|;\\s*)$token\\s*\\=').hasMatch(_document.cookie);
  }

  /// Gets the deserialized value associated to the specified key.
  /// Returns a `null` reference if the cookie is not found.
  dynamic getObject(String key) {
    try {
      final value = this[key];
      return value is String ? json.decode(value) : null;
    }

    on FormatException {
      return null;
    }
  }

  /// Removes the cookie with the specified [key] and its associated value.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key, [CookieOptions options]) {
    final previousValue = this[key];
    _removeItem(key, options);
    _onChanges.add({
      key: SimpleChange(previousValue: previousValue)
    });

    return previousValue;
  }

  /// Associates a given [value] to the specified [key].
  /// Throws an [ArgumentError] if the specified key is invalid.
  void set(String key, String value, [CookieOptions options]) {
    if (key.isEmpty || RegExp(r'^(domain|expires|max-age|path|secure)$').hasMatch(key))
      throw ArgumentError.value(key, 'key', 'Invalid cookie name.');

    final cookieOptions = _getOptions(options).toString();
    var cookieValue = '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}';
    if (cookieOptions.isNotEmpty) cookieValue += '; $cookieOptions';

    final previousValue = this[key];
    _document.cookie = cookieValue;
    _onChanges.add({
      key: SimpleChange(currentValue: value, previousValue: previousValue)
    });
  }

  /// Serializes and associates a given [value] to the specified [key].
  void setObject(String key, Object value, [CookieOptions options]) => set(key, json.encode(value), options);

  /// Returns a string representation of this object.
  @override
  String toString() => _document.cookie;

  /// Merges the default cookie options with the specified ones.
  CookieOptions _getOptions([CookieOptions options]) {
    options ??= CookieOptions();
    return CookieOptions(
      domain: options.domain.isNotEmpty ? options.domain : defaults.domain,
      expires: options.expires != null ? options.expires : defaults.expires,
      path: options.path.isNotEmpty ? options.path : defaults.path,
      secure: options.secure ? options.secure : defaults.secure
    );
  }

  /// Removes the value associated to the specified [key].
  void _removeItem(String key, [CookieOptions options]) {
    if (!containsKey(key)) return;
    final cookieOptions = _getOptions(options);
    _document.cookie = '${Uri.encodeComponent(key)}=; ${CookieOptions(
      domain: cookieOptions.domain,
      expires: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
      path: cookieOptions.path,
      secure: cookieOptions.secure
    )}';
  }
}
