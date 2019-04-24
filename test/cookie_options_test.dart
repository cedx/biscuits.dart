import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [CookieOptions] class.
void main() => group('CookieOptions', () {
  final options = CookieOptions(
    domain: 'domain.com',
    expires: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
    path: '/path',
    secure: true
  );

  group('.fromJson()', () {
    test('should return an instance with default values for an empty map', () {
      final cookieOptions = CookieOptions.fromJson({});
      expect(cookieOptions.domain, isEmpty);
      expect(cookieOptions.expires, isNull);
      expect(cookieOptions.path, isEmpty);
      expect(cookieOptions.secure, isFalse);
    });

    test('should return an initialized instance for a non-empty map', () {
      final cookieOptions = CookieOptions.fromJson(options.toJson());
      expect(cookieOptions.domain, options.domain);
      expect(cookieOptions.expires.millisecondsSinceEpoch, options.expires.millisecondsSinceEpoch);
      expect(cookieOptions.path, options.path);
      expect(cookieOptions.secure, options.secure);
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      final map = CookieOptions().toJson();
      expect(map, hasLength(4));
      expect(map['domain'], isEmpty);
      expect(map['expires'], isNull);
      expect(map['path'], isEmpty);
      expect(map['secure'], isFalse);
    });

    test('should return a non-empty map for an initialized instance', () {
      final map = options.toJson();
      expect(map, hasLength(4));
      expect(map['domain'], 'domain.com');
      expect(map['expires'], '1970-01-01T00:00:00.000Z');
      expect(map['path'], '/path');
      expect(map['secure'], isTrue);
    });
  });

  group('.toString()', () {
    test('should return an empty string for a newly created instance', () {
      expect(CookieOptions().toString(), isEmpty);
    });

    test('should return a format like "expires=<expires>; domain=<domain>; path=<path>; secure" for an initialized instance', () {
      expect(options.toString(), 'expires=Thu, 01 Jan 1970 00:00:00 GMT; domain=domain.com; path=/path; secure');
    });
  });
});
