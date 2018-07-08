import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [CookieOptions] class.
void main() => group('CookieOptions', () {
  var options = CookieOptions(
    domain: 'domain.com',
    expires: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
    path: '/path',
    secure: true
  );

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = const CookieOptions().toJson();
      expect(map, hasLength(4));
      expect(map['domain'], isEmpty);
      expect(map['expires'], isNull);
      expect(map['path'], isEmpty);
      expect(map['secure'], isFalse);
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = options.toJson();
      expect(map, hasLength(4));
      expect(map['domain'], equals('domain.com'));
      expect(map['expires'], equals('1970-01-01T00:00:00.000Z'));
      expect(map['path'], equals('/path'));
      expect(map['secure'], isTrue);
    });
  });

  group('.toString()', () {
    test('should return an empty string for a newly created instance', () {
      expect(const CookieOptions().toString(), isEmpty);
    });

    test('should return a format like "expires=<expires>; domain=<domain>; path=<path>; secure" for an initialized instance', () {
      expect(options.toString(), equals('expires=Thu, 01 Jan 1970 00:00:00 GMT; domain=domain.com; path=/path; secure'));
    });
  });
});
