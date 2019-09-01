part of '../biscuits.dart';

/// Defines the attributes of a HTTP cookie.
@JsonSerializable()
class CookieOptions {

  /// Creates new cookie options.
  CookieOptions({this.domain = '', this.expires, Duration maxAge, this.path = '', this.secure = false}) {
    if (maxAge != null) this.maxAge = maxAge;
  }

  /// Creates new cookie options from the specified [map] in JSON format.
  factory CookieOptions.fromJson(Map<String, dynamic> map) {
    final options = _$CookieOptionsFromJson(map);
    if (map['maxAge'] is int) options.maxAge = Duration(seconds: map['maxAge']);
    return options;
  }

  /// The domain for which the cookie is valid.
  @JsonKey(defaultValue: '')
  String domain;

  /// The expiration date and time for the cookie. A `null` value indicates a session cookie.
  DateTime expires;

  /// The maximum duration until the cookie expires. A `null` value indicates a session cookie.
  @JsonKey(ignore: true)
  Duration get maxAge {
    if (expires == null) return null;
    final now = DateTime.now();
    return expires.isAfter(now) ? expires.toUtc().difference(now.toUtc()) : Duration.zero;
  }

  set maxAge(Duration value) => expires = value == null ? null : DateTime.now().add(value);

  /// The path to which the cookie applies.
  @JsonKey(defaultValue: '')
  String path;

  /// Value indicating whether to transmit the cookie over HTTPS only.
  @JsonKey(defaultValue: false)
  bool secure;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$CookieOptionsToJson(this);

  /// Returns a string representation of this object.
  @override
  String toString() {
    final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
    return [
      if (expires != null) 'expires=${formatter.format(expires.toUtc())} GMT',
      if (domain.isNotEmpty) 'domain=$domain',
      if (path.isNotEmpty) 'path=$path',
      if (secure) 'secure'
    ].join('; ');
  }
}
