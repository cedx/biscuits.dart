import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [SimpleChange] class.
void main() => group('SimpleChange', () {
  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = SimpleChange().toJson();
      expect(map, hasLength(2));
      expect(map['currentValue'], isNull);
      expect(map['previousValue'], isNull);
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = SimpleChange(currentValue: 'bar', previousValue: 'baz').toJson();
      expect(map, hasLength(2));
      expect(map['currentValue'], equals('bar'));
      expect(map['previousValue'], equals('baz'));
    });
  });

  group('.toString()', () {
    var data = SimpleChange(currentValue: 'bar', previousValue: 'baz').toString();

    test('should start with the class name', () {
      expect(data, contains('SimpleChange {'));
    });

    test('should contain the instance properties', () {
      expect(data, contains('"currentValue":"bar"'));
      expect(data, contains('"previousValue":"baz"'));
    });
  });
});
