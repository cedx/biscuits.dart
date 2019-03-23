@TestOn('browser')
import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [SimpleChange] class.
void main() => group('SimpleChange', () {
  group('.fromJson()', () {
    test('should return an empty instance with an empty map', () {
      final change = SimpleChange<String>.fromJson({});
      expect(change.currentValue, isNull);
      expect(change.previousValue, isNull);
    });

    test('should return an initialized instance with a non-empty map', () {
      final change = SimpleChange<int>.fromJson({'currentValue': 123, 'previousValue': 456});
      expect(change.currentValue, 123);
      expect(change.previousValue, 456);
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      final map = const SimpleChange<String>().toJson();
      expect(map, hasLength(2));
      expect(map['currentValue'], isNull);
      expect(map['previousValue'], isNull);
    });

    test('should return a non-empty map for an initialized instance', () {
      final map = const SimpleChange<String>(currentValue: 'bar', previousValue: 'baz').toJson();
      expect(map, hasLength(2));
      expect(map['currentValue'], 'bar');
      expect(map['previousValue'], 'baz');
    });
  });

  group('.toString()', () {
    final data = const SimpleChange<int>(currentValue: 123, previousValue: 456).toString();

    test('should start with the class name', () {
      expect(data, contains('SimpleChange {'));
    });

    test('should contain the instance properties', () {
      expect(data, allOf(contains('"currentValue":123'), contains('"previousValue":456')));
    });
  });
});
