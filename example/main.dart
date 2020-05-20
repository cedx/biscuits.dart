// ignore_for_file: avoid_print
import "dart:convert";
import "package:biscuits/biscuits.dart";

/// Tests the cookie service.
void main() {
	final cookies = Cookies(defaults: CookieOptions(
		domain: "domain.com",
		path: "/path",
		secure: true
	));

	// The defaut options used when a cookie is created or removed.
	print(jsonEncode(cookies.defaults));
	// {"domain": "www.domain.com", "expires": null, "path": "/", "secure": true}

	// Write the cookies.
	print(cookies.containsKey("foo")); // false
	print(cookies.containsKey("baz")); // false
	print(cookies.isEmpty); // true

	cookies["foo"] = "bar";
	print(cookies.containsKey("foo")); // true
	print(cookies.length); // 1

	cookies.setObject("baz", <String, int>{"qux": 123});
	print(cookies.containsKey("baz")); // true
	print(cookies.length); // 2

	// Read the cookies.
	print(cookies["foo"].runtimeType); // "String"
	print(cookies["foo"]); // "bar"

	print(cookies.getObject("baz").runtimeType); // "_JsonMap"
	print(cookies.getObject("baz")); // {"qux": 123}
	print(cookies.getObject("baz")["qux"]); // 123

	// Delete the cookies.
	cookies.remove("foo");
	print(cookies.containsKey("foo")); // false
	print(cookies.length); // 1

	cookies.clear();
	print(cookies.containsKey("baz")); // false
	print(cookies.isEmpty); // true
}
