path: blob/master
source: lib/src/cookies.dart

# Programming interface
This package provides a service dedicated to the cookie management: the `Cookies` class.

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();

  cookies['foo'] = 'bar';
  print(cookies['foo']); // "bar"

  cookies.setObject('foo', <String, String>{'baz': 'qux'});
  print(cookies.getObject('foo')); // {"baz": "qux"}
}
```

The `Cookies` class implements the [`Map`](https://api.dartlang.org/dev/dart-core/Map-class.html) interface and has the following API:

## CookieOptions get **defaults**
Returns the default options to pass when setting cookies:

```dart
import 'dart:convert';
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(json.encode(cookies.defaults));
  // {"domain": "", "expires": null, "path": "", "secure": false}

  cookies.defaults
    ..domain = 'domain.com'
    ..path = '/www'
    ..secure = true;

  print(json.encode(cookies.defaults));
  // {"domain": "domain.com", "expires": null, "path": "/www", "secure": true}
}
```

## Iterable&lt;String&gt; get **keys**
Returns the keys of the cookies associated with the current document:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies.keys.toList()); // []

  cookies['foo'] = 'bar';
  print(cookies.keys.toList()); // ["foo"]
}
```

## int get **length**
Returns the number of cookies associated with the current document:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies.length); // 0

  cookies['foo'] = 'bar';
  print(cookies.length); // 1
}
```

## String **operator []**(String key)
Returns the value associated to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies['foo']); // null

  cookies['foo'] = 'bar';
  print(cookies['foo']); // "bar"
}
```

Returns a `null` reference if the key is not found.

## void **operator []=**(String key, String value)
Associates a given value to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies['foo']); // null

  cookies['foo'] = 'bar';
  print(cookies['foo']); // "bar"
}
```

## void **clear**()
Removes all cookies associated with the current document:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();

  cookies['foo'] = 'bar';
  print(cookies.length); // 1

  cookies.clear();
  print(cookies.length); // 0
}
```

## bool **containsKey**(String key)
Returns a boolean value indicating whether the current document has a cookie with the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies.has('foo')); // false

  cookies['foo'] = 'bar';
  print(cookies.has('foo')); // true
}
```

## dynamic **getObject**(String key)
Deserializes and returns the value associated to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies.getObject('foo')); // null

  cookies.setObject('foo', <String, String>{'bar': 'baz'});
  print(cookies.getObject('foo')); // {"bar": "baz"}
}
```

!!! info
    The value is deserialized using the [`JsonCodec.decode`](https://api.dartlang.org/stable/dart-convert/JsonCodec/decode.html) method.

Returns a `null` reference if the key is not found.

## String **remove**(String key, [CookieOptions options])
Removes the value associated to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();

  cookies['foo'] = 'bar';
  print(cookies.containsKey('foo')); // true

  print(cookies.remove('foo')); // "bar"
  print(cookies.containsKey('foo')); // false
}
```

Returns the value associated with the key before it was removed.

## void **set**(String key, String value, [CookieOptions options])
Associates a given value to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies['foo']); // null

  cookies.set('foo', 'bar');
  print(cookies['foo']); // "bar"
}
```

## void **setObject**(String key, Object value, [CookieOptions options])
Serializes and associates a given value to the specified key:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  print(cookies.getObject('foo')); // null

  cookies.setObject('foo', {bar: 'baz'});
  print(cookies.getObject('foo')); // {bar: "baz"}
}
```

!!! info
    The value is serialized using the [`JsonCodec.encode`](https://api.dartlang.org/stable/dart-convert/JsonCodec/encode.html) method.
