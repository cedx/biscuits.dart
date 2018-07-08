part of biscuits;

/// Defines the attributes of a HTTP cookie.
class CookieOptions {

  /// Creates new cookie options.
  CookieOptions({this.domain = '', this.expires, this.path = '', this.secure = false});

  /// The domain for which the cookie is valid.
  String domain;

  /// The expiration date and time for the cookie.
  DateTime expires;

  /// The path to which the cookie applies.
  String path;

  /// Value indicating whether to transmit the cookie over HTTPS only.
  bool secure;

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => {
    'domain': domain,
    'expires': expires != null ? expires.toIso8601String() : null,
    'path': path,
    'secure': secure
  };

  /// Returns a string representation of this object.
  @override
  String toString() {
    var formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
    var value = [];
    if (expires != null) value.add('expires=${formatter.format(expires.toUtc())} GMT');
    if (domain.isNotEmpty) value.add('domain=$domain');
    if (path.isNotEmpty) value.add('path=$path');
    if (secure) value.add('secure');
    return value.join('; ');
  }
}
