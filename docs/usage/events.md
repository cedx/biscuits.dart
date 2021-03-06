# Events
The `Cookies` class triggers a `changes` event every time one or several values are changed (added, removed or updated) through this class.

These events are exposed as `Stream`, you can listen to them using the `onChanges` property:

```dart
import "package:biscuits/biscuits.dart";

void main() {
	Cookies().onChanges.listen((changes) {
		for (final entry in changes.entries) print("${entry.key}: ${entry.value}");
	});
}
```

The changes are expressed as a `Map` of `SimpleChange` instances, where a `null` property indicates an absence of value:

```dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	cookies.onChanges.listen((changes) {
		for (final entry in changes.entries) print({
			"key": entry.key,
			"current": entry.value.currentValue,
			"previous": entry.value.previousValue
		});
	});

	cookies["foo"] = "bar";
	// Prints: {"key": "foo", "current": "bar", "previous": null}

	cookies["foo"] = "baz";
	// Prints: {"key": "foo", "current": "baz", "previous": "bar"}

	cookies.remove("foo");
	// Prints: {"key": "foo", "current": null, "previous": "baz"}
}
```

The values contained in the `currentValue` and `previousValue` properties of the `SimpleChange` instances are the raw cookie values. If you use the `Cookies.setObject()` method to set a cookie, you will get the serialized string value, not the original value passed to the method:

```dart
cookies.setObject("foo", <String, String>{"bar": "baz"});
// Prints: {"key": "foo", "current": "{\"bar\": \"baz\"}", "previous": null}
```
