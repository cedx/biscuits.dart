import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [CookieOptions] class.
void main() => group('CookieOptions', () {
  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = CookieOptions().toJson();
      expect(map, hasLength(4));
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = CookieOptions().toJson();
      expect(map, hasLength(4));
    });
  });

  group('.toString()', () {
    var data = CookieOptions().toString();

    test('should start with the class name', () {
      //expect(data, contains('CookieOptions {'));
    });

    test('should contain the instance properties', () {
      // TODO
    });
  });
});
