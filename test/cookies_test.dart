import 'dart:html' as dom;
import 'package:biscuits/biscuits.dart';
import 'package:test/test.dart';

/// Tests the features of the [Cookies] class.
void main() => group('Cookies', () {
  Map<String, String> getNativeCookies() {
    final nativeCookies = <String, String>{};
    if (dom.document.cookie.isNotEmpty) for (final value in dom.document.cookie.split(';')) {
      final index = value.indexOf('=');
      nativeCookies[value.substring(0, index)] = value.substring(index + 1);
    }

    return nativeCookies;
  }

  group('.keys', () {
    test('should return an empty array if the current document has no associated cookie', () {
      expect(Cookies().keys, hasLength(getNativeCookies().keys.length));
    });

    test('should return the keys of the cookies associated with the current document', () {
      dom.document.cookie = 'key1=foo';
      dom.document.cookie = 'key2=bar';
      expect(Cookies().keys, orderedEquals(['key1', 'key2']));
    });
  });

  group('.length', () {
    test('should return zero if the current document has no associated cookie', () {
      expect(Cookies(), hasLength(getNativeCookies().length));
    });

    test('should return the number of cookies associated with the current document', () {
      final nativeCookies = getNativeCookies();
      dom.document.cookie = 'length1=foo';
      dom.document.cookie = 'length2=bar';
      expect(Cookies().length, inInclusiveRange(nativeCookies.length, nativeCookies.length + 2));
    });
  });

  group('.onChanges', () {
    test('should trigger an event when a cookie is added', () {
      dom.document.cookie = 'onChanges=; expires=Thu, 01 Jan 1970 00:00:00 GMT';

      final cookies = Cookies();
      cookies.onChanges.listen(expectAsync1((changes) {
        expect(changes, hasLength(1));

        final record = changes.values.first;
        expect(changes.keys.first, equals('onChanges'));
        expect(record.currentValue, equals('foo'));
        expect(record.previousValue, isNull);
      }));

      cookies['onChanges'] = 'foo';
    });

    test('should trigger an event when a cookie is updated', () {
      dom.document.cookie = 'onChanges=foo';

      final cookies = Cookies();
      cookies.onChanges.listen(expectAsync1((changes) {
        expect(changes, hasLength(1));

        final record = changes.values.first;
        expect(changes.keys.first, equals('onChanges'));
        expect(record.currentValue, equals('bar'));
        expect(record.previousValue, equals('foo'));
      }));

      cookies['onChanges'] = 'bar';
    });

    test('should trigger an event when a cookie is removed', () {
      dom.document.cookie = 'onChanges=bar';

      final cookies = Cookies();
      cookies.onChanges.listen(expectAsync1((changes) {
        expect(changes, hasLength(1));

        final record = changes.values.first;
        expect(changes.keys.first, equals('onChanges'));
        expect(record.currentValue, isNull);
        expect(record.previousValue, equals('bar'));
      }));

      cookies.remove('onChanges');
    });

    test('should trigger an event when all the cookies are removed', () {
      dom.document.cookie = 'onChanges1=foo';
      dom.document.cookie = 'onChanges2=bar';

      final cookies = Cookies();
      cookies.onChanges.listen(expectAsync1((changes) {
        expect(changes.length, greaterThanOrEqualTo(2));

        var records = changes.entries.where((entry) => entry.key == 'onChanges1').map((entry) => entry.value).toList();
        expect(records, hasLength(1));
        expect(records.first.currentValue, isNull);
        expect(records.first.previousValue, equals('foo'));

        records = changes.entries.where((entry) => entry.key == 'onChanges2').map((entry) => entry.value).toList();
        expect(records, hasLength(1));
        expect(records.first.currentValue, isNull);
        expect(records.first.previousValue, equals('bar'));
      }));

      cookies.clear();
    });
  });

  group('.clear()', () {
    test('should remove all the cookies associated with the current document', () {
      dom.document.cookie = 'clear1=foo';
      dom.document.cookie = 'clear2=bar';

      Cookies().clear();
      expect(dom.document.cookie, isNot(contains('clear1')));
      expect(dom.document.cookie, isNot(contains('clear2')));
    });
  });

  group('.containsKey()', () {
    test('should return `false` if the current document has an associated cookie with the specified key', () {
      expect(Cookies().containsKey('foo'), isFalse);
    });

    test('should return `true` if the current document does not have an associated cookie with the specified key', () {
      dom.document.cookie = 'has1=foo';
      dom.document.cookie = 'has2=bar';

      final cookies = Cookies();
      expect(cookies.containsKey('has1'), isTrue);
      expect(cookies.containsKey('has2'), isTrue);
      expect(cookies.containsKey('foo'), isFalse);
      expect(cookies.containsKey('bar'), isFalse);
    });
  });

  group('.get()', () {
    test('should properly get the cookies associated with the current document', () {
      final cookies = Cookies();
      expect(cookies['foo'], isNull);

      dom.document.cookie = 'get1=foo';
      expect(cookies['get1'], equals('foo'));

      dom.document.cookie = 'get2=123';
      expect(cookies['get2'], equals('123'));
    });

    test('should return the given default value if the cookie is not found', () {
      final cookies = Cookies();
      expect(cookies.get('foo'), isNull);
      expect(cookies.get('foo', 'bar'), equals('bar'));
    });
  });

  group('.getObject()', () {
    test('should properly get the deserialized cookies associated with the current document', () {
      final cookies = Cookies();
      expect(cookies.getObject('foo'), isNull);

      dom.document.cookie = 'getObject1=123';
      expect(cookies.getObject('getObject1'), equals(123));

      dom.document.cookie = 'getObject2=%22bar%22';
      expect(cookies.getObject('getObject2'), equals('bar'));

      dom.document.cookie = 'getObject3=%7B%22key%22%3A%22value%22%7D';
      final object = cookies.getObject('getObject3');
      expect(object, allOf(isMap, hasLength(1)));
      expect(object['key'], equals('value'));
    });

    test('should return a `null` reference if the value can\'t be deserialized', () {
      dom.document.cookie = 'getObject4=bar';
      expect(Cookies().getObject('getObject4'), isNull);
    });

    test('should return the given default value if the cookie is not found', () {
      final cookies = Cookies();
      expect(cookies.getObject('foo'), isNull);
      expect(cookies.getObject('foo', {}), allOf(isMap, isEmpty));
    });
  });

  group('.remove()', () {
    test('should properly remove the cookies associated with the current document', () {
      dom.document.cookie = 'remove1=foo';
      dom.document.cookie = 'remove2=bar';

      final cookies = Cookies()..remove('remove1');
      expect(dom.document.cookie, isNot(contains('remove1')));
      expect(dom.document.cookie, contains('remove2=bar'));

      cookies.remove('remove2');
      expect(dom.document.cookie, isNot(contains('remove2')));
    });
  });

  group('.set()', () {
    test('should properly set the cookies associated with the current document', () {
      final cookies = Cookies();
      expect(dom.document.cookie, isNot(contains('set1')));
      expect(dom.document.cookie, isNot(contains('set2')));

      cookies['set1'] = 'foo';
      expect(dom.document.cookie, contains('set1=foo'));
      expect(dom.document.cookie, isNot(contains('set2')));

      cookies['set2'] = 'bar';
      expect(dom.document.cookie, contains('set1=foo'));
      expect(dom.document.cookie, contains('set2=bar'));

      cookies['set1'] = '123';
      expect(dom.document.cookie, contains('set1=123'));
      expect(dom.document.cookie, contains('set2=bar'));
    });

    test('should throw an error if the specified key is a reserved word', () {
      final cookies = Cookies();
      expect(() => cookies['domain'] = 'foo', throwsArgumentError);
      expect(() => cookies['expires'] = 'foo', throwsArgumentError);
      expect(() => cookies['max-age'] = 'foo', throwsArgumentError);
      expect(() => cookies['path'] = 'foo', throwsArgumentError);
      expect(() => cookies['secure'] = 'foo', throwsArgumentError);
    });
  });

  group('.setObject()', () {
    test('should properly serialize and set the cookies associated with the current document', () {
      final cookies = Cookies();
      expect(dom.document.cookie, isNot(contains('setObject1')));
      expect(dom.document.cookie, isNot(contains('setObject2')));

      cookies.setObject('setObject1', 123);
      expect(dom.document.cookie, contains('setObject1=123'));
      expect(dom.document.cookie, isNot(contains('setObject2')));

      cookies.setObject('setObject2', 'foo');
      expect(dom.document.cookie, contains('setObject1=123'));
      expect(dom.document.cookie, contains('setObject2=%22foo%22'));

      cookies.setObject('setObject1', <String, String>{'key': 'value'});
      expect(dom.document.cookie, contains('setObject1=%7B%22key%22%3A%22value%22%7D'));
      expect(dom.document.cookie, contains('setObject2=%22foo%22'));
    });

    test('should throw an error if the specified key is a reserved word', () {
      final cookies = Cookies();
      expect(() => cookies.setObject('domain', 'foo'), throwsArgumentError);
      expect(() => cookies.setObject('expires', 'foo'), throwsArgumentError);
      expect(() => cookies.setObject('max-age', 'foo'), throwsArgumentError);
      expect(() => cookies.setObject('path', 'foo'), throwsArgumentError);
      expect(() => cookies.setObject('secure', 'foo'), throwsArgumentError);
    });
  });

  group('.toJson()', () {
    test('should return an empty map if the current document has no associated cookie', () {
      final cookies = Cookies()..clear();
      expect(cookies.toJson(), isEmpty);
    });

    test('should return a non-empty map if the current document has associated cookies', () {
      final cookies = Cookies()..clear();
      cookies['foo'] = 'bar';
      cookies['baz'] = 'qux';

      final map = cookies.toJson();
      expect(map, hasLength(2));
      expect(map['foo'], equals('bar'));
      expect(map['baz'], equals('qux'));
    });
  });

  group('.toString()', () {
    test('should be the same value as the `document.cookie` property', () {
      expect(Cookies().toString(), equals(dom.document.cookie));
    });
  });
});
