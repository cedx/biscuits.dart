part of biscuits;

/// Defines the attributes of a HTTP cookie.
@JsonSerializable()
class CookieOptions {

  /// Creates new cookie options.
  CookieOptions({this.domain = '', this.expires, this.path = '', this.secure = false});

  /// Creates new cookie options from the specified [map] in JSON format.
  factory CookieOptions.fromJson(Map<String, dynamic> map) => _$CookieOptionsFromJson(map);

  /// The domain for which the cookie is valid.
  @JsonKey(defaultValue: '')
  String domain;

  /// The expiration date and time for the cookie.
  DateTime expires;

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
    var formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
    var value = [];
    if (expires != null) value.add('expires=${formatter.format(expires.toUtc())} GMT');
    if (domain.isNotEmpty) value.add('domain=$domain');
    if (path.isNotEmpty) value.add('path=$path');
    if (secure) value.add('secure');
    return value.join('; ');
  }
}
