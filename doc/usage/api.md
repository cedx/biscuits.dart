---
path: src/branch/main
source: lib/src/cookies.dart
---

# Programming interface
This package provides a service dedicated to the cookie management: the `Cookies` class.

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();

	cookies["foo"] = "bar";
	print(cookies["foo"]); // "bar"

	cookies.setObject("foo", <String, String>{"baz": "qux"});
	print(cookies.getObject("foo")); // {"baz": "qux"}
}
```

The `Cookies` class implements the [`Map`](https://api.dart.dev/stable/dart-core/Map-class.html) interface and has the following API:

## CookieOptions get **defaults**
Returns the default [options](options.md) to pass when setting cookies:

``` dart
import "dart:convert";
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(jsonEncode(cookies.defaults));
	// {"domain": "", "expires": null, "path": "", "secure": false}

	cookies.defaults
		..domain = "domain.com"
		..path = "/www"
		..secure = true;

	print(jsonEncode(cookies.defaults));
	// {"domain": "domain.com", "expires": null, "path": "/www", "secure": true}
}
```

## Iterable&lt;String&gt; get **keys**
Returns the keys of the cookies associated with the current document:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.keys.toList()); // []

	cookies["foo"] = "bar";
	print(cookies.keys.toList()); // ["foo"]
}
```

## int get **length**
Returns the number of cookies associated with the current document:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.length); // 0

	cookies["foo"] = "bar";
	print(cookies.length); // 1
}
```

## void **clear**()
Removes all cookies associated with the current document:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();

	cookies["foo"] = "bar";
	print(cookies.length); // 1

	cookies.clear();
	print(cookies.length); // 0
}
```

## bool **containsKey**(String key)
Returns a boolean value indicating whether the current document has a cookie with the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.containsKey("foo")); // false

	cookies["foo"] = "bar";
	print(cookies.containsKey("foo")); // true
}
```

## String **get**(String key, [String defaultValue])
Returns the value associated to the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.get("foo")); // null
	print(cookies.get("foo", "qux")); // "qux"

	cookies["foo"] = "bar";
	print(cookies.get("foo")); // "bar"
}
```

Returns a `null` reference or the given default value if the key is not found.

## dynamic **getObject**(String key, [dynamic defaultValue])
Deserializes and returns the value associated to the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.getObject("foo")); // null
	print(cookies.getObject("foo", "qux")); // "qux"

	cookies.setObject("foo", <String, String>{"bar": "baz"});
	print(cookies.getObject("foo")); // {"bar": "baz"}
}
```

!!! info
	The value is deserialized using the [`jsonDecode`](https://api.dart.dev/stable/dart-convert/jsonDecode.html) function.

Returns a `null` reference or the given default value if the key is not found.

## String **putIfAbsent**(String key, String Function() ifAbsent, [CookieOptions options])
Looks up the cookie with the specified key, or add a new cookie if it isn't there.

Returns the value associated to the key, if there is one. Otherwise calls `ifAbsent` to get a new value,
associates the key to that value, and then returns the new value:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.containsKey("foo")); // false

	var value = cookies.putIfAbsent("foo", () => "bar");
	print(cookies.containsKey("foo")); // true
	print(value); // "bar"

	value = cookies.putIfAbsent("foo", () => "qux");
	print(value); // "bar"
}
```

## dynamic **putObjectIfAbsent**(String key, dynamic Function() ifAbsent, [CookieOptions options])
Looks up the cookie with the specified key, or add a new cookie if it isn't there.

Returns the deserialized value associated to the key, if there is one. Otherwise calls `ifAbsent` to get a new value,
serializes and associates the key to that value, and then returns the new value:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.containsKey("foo")); // false

	var value = cookies.putObjectIfAbsent("foo", () => 123);
	print(cookies.containsKey("foo")); // true
	print(value); // 123

	value = cookies.putObjectIfAbsent("foo", () => 456);
	print(value); // 123
}
```

!!! info
	The value is serialized using the [`jsonEncode`](https://api.dart.dev/stable/dart-convert/jsonEncode.html) function,
	and deserialized using the [`jsonDecode`](https://api.dart.dev/stable/dart-convert/jsonDecode.html) function.

## String **remove**(String key, [CookieOptions options])
Removes the value associated to the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();

	cookies["foo"] = "bar";
	print(cookies.containsKey("foo")); // true

	print(cookies.remove("foo")); // "bar"
	print(cookies.containsKey("foo")); // false
}
```

Returns the value associated with the key before it was removed.

## void **set**(String key, String value, [CookieOptions options])
Associates a given value to the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies["foo"]); // null

	cookies.set("foo", "bar");
	print(cookies["foo"]); // "bar"
}
```

## void **setObject**(String key, dynamic value, [CookieOptions options])
Serializes and associates a given value to the specified key:

``` dart
import "package:biscuits/biscuits.dart";

void main() {
	final cookies = Cookies();
	print(cookies.getObject("foo")); // null

	cookies.setObject("foo", {bar: "baz"});
	print(cookies.getObject("foo")); // {bar: "baz"}
}
```

!!! info
	The value is serialized using the [`jsonEncode`](https://api.dart.dev/stable/dart-convert/jsonEncode.html) function.
