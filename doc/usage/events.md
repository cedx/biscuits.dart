path: src/branch/master
source: lib/src/simple_change.dart

# Events
The [`Cookies`](api.md) class triggers a `changes` event every time one or several values are changed (added, removed or updated) through this class.

These events are exposed as [`Stream`](https://api.dartlang.org/stable/dart-async/Stream-class.html), you can listen to them using the `onChanges` property:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  Cookies().onChanges.listen((changes) {
    for (final entry in changes.entries) print('${entry.key}: ${entry.value}');
  });
}
```

The changes are expressed as a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of [`SimpleChange<String>`](https://git.belin.io/cedx/biscuits.dart/src/branch/master/lib/src/simple_change.dart) instances, where a `null` property indicates an absence of value:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();

  cookies.onChanges.listen((changes) {
    for (final entry in changes.entries) print(<String, String>{
      'key': entry.key,
      'current': entry.value.currentValue,
      'previous': entry.value.previousValue
    });
  });

  cookies['foo'] = 'bar';
  // Prints: {"key": "foo", "current": "bar", "previous": null}

  cookies['foo'] = 'baz';
  // Prints: {"key": "foo", "current": "baz", "previous": "bar"}

  cookies.remove('foo');
  // Prints: {"key": "foo", "current": null, "previous": "baz"}
}
```

The values contained in the `currentValue` and `previousValue` properties of the `SimpleChange<String>` instances are the raw cookie values. If you use the `Cookies#setObject()` method to set a cookie, you will get the serialized string value, not the original value passed to the method:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies();
  cookies.setObject('foo', <String, String>{'bar': 'baz'});
  // Prints: {"key": "foo", "current": "{\"bar\": \"baz\"}", "previous": null}
}
```
