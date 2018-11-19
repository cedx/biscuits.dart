part of '../biscuits.dart';

/// Provides access to the HTTP cookies.
/// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
class Cookies extends Object with MapMixin<String, String> { // ignore: prefer_mixin

  /// Creates a new cookie service.
  Cookies({CookieOptions defaults, dom.Document document}): defaults = defaults ?? CookieOptions(), _document = document ?? dom.document;

  /// The underlying HTML document.
  final dom.Document _document;

  /// The handler of "changes" events.
  final StreamController<Map<String, SimpleChange<String>>> _onChanges = StreamController<Map<String, SimpleChange<String>>>.broadcast();

  /// The default cookie options.
  final CookieOptions defaults;

  /// The keys of the cookies associated with the current document.
  @override
  Iterable<String> get keys {
    final keys = _document.cookie.replaceAll(RegExp(r'((?:^|\s*;)[^=]+)(?=;|$)|^\s*|\s*(?:=[^;]*)?(?:\1|$)'), '');
    return keys.isNotEmpty ? keys.split(RegExp(r'\s*(?:=[^;]*)?;\s*')).map(Uri.decodeComponent) : <String>[];
  }

  /// The stream of "changes" events.
  Stream<Map<String, SimpleChange<String>>> get onChanges => _onChanges.stream;

  /// Gets the value associated to the specified [key].
  @override
  String operator [](Object key) => get(key);

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => set(key, value);

  /// Removes all cookies associated with the current document.
  @override
  void clear() {
    final changes = <String, SimpleChange<String>>{};
    for (final key in keys) {
      changes[key] = SimpleChange<String>(previousValue: this[key]);
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

  /// Gets the value associated to the specified [key].
  /// Returns the given default value if the cookie is not found.
  String get(String key, [String defaultValue]) {
    if (!containsKey(key)) return defaultValue;

    try {
      final token = Uri.encodeComponent(key).replaceAll(RegExp('[-.+*]'), r'\$&');
      final scanner = RegExp('(?:(?:^|.*;)\\s*$token\\s*\\=\\s*([^;]*).*\$)|^.*\$');
      return Uri.decodeComponent(_document.cookie.replaceAllMapped(scanner, (match) => match[1]));
    }

    on Exception {
      return defaultValue;
    }
  }

  /// Gets the deserialized value associated to the specified key.
  /// Returns the given default value if the cookie is not found.
  dynamic getObject(String key, [Object defaultValue]) {
    try {
      final value = this[key];
      return value is String ? json.decode(value) : defaultValue;
    }

    on FormatException {
      return defaultValue;
    }
  }

  /// Removes the cookie with the specified [key] and its associated value.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key, [CookieOptions options]) {
    final previousValue = this[key];
    _removeItem(key, options);
    _onChanges.add({
      key: SimpleChange<String>(previousValue: previousValue)
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
      key: SimpleChange<String>(currentValue: value, previousValue: previousValue)
    });
  }

  /// Serializes and associates a given [value] to the specified [key].
  void setObject(String key, Object value, [CookieOptions options]) => set(key, json.encode(value), options);

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(this);

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
    final cookieOptions = _getOptions(options)..expires = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);
    _document.cookie = '${Uri.encodeComponent(key)}=; $cookieOptions';
  }
}
