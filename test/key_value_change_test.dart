import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [KeyValueChange] class.
void main() => group('KeyValueChange', () {
  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = new KeyValueChange('').toJson();
      expect(map, hasLength(3));
      expect(map['currentValue'], isNull);
      expect(map['key'], isEmpty);
      expect(map['previousValue'], isNull);
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = new KeyValueChange('foo', currentValue: 'bar', previousValue: 'baz').toJson();
      expect(map, hasLength(3));
      expect(map['currentValue'], equals('bar'));
      expect(map['key'], equals('foo'));
      expect(map['previousValue'], equals('baz'));
    });
  });

  group('.toString()', () {
    var data = new KeyValueChange('foo', currentValue: 'bar', previousValue: 'baz').toString();

    test('should start with the class name', () {
      expect(data, contains('KeyValueChange {'));
    });

    test('should contain the instance properties', () {
      expect(data, contains('"currentValue":"bar"'));
      expect(data, contains('"key":"foo"'));
      expect(data, contains('"previousValue":"baz"'));
    });
  });
});
