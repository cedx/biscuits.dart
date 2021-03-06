import "dart:html" as dom;
import "package:biscuits/biscuits.dart";
import "package:test/test.dart";

/// Tests the features of the [Cookies] class.
void main() => group("Cookies", () {
	/// Returns a map of the native cookies.
	Map<String, String> getNativeCookies() {
		final nativeCookies = <String, String>{};
		if (dom.document.cookie.isNotEmpty) for (final value in dom.document.cookie.split(";")) {
			final index = value.indexOf("=");
			nativeCookies[value.substring(0, index)] = value.substring(index + 1);
		}

		return nativeCookies;
	}

	group(".keys", () {
		test("should return an empty array if the current document has no associated cookie", () {
			expect(Cookies().keys, hasLength(getNativeCookies().keys.length));
		});

		test("should return the keys of the cookies associated with the current document", () {
			dom.document.cookie = "key1=foo";
			dom.document.cookie = "key2=bar";
			expect(Cookies().keys, orderedEquals(["key1", "key2"]));
		});
	});

	group(".length", () {
		test("should return zero if the current document has no associated cookie", () {
			expect(Cookies(), hasLength(getNativeCookies().length));
		});

		test("should return the number of cookies associated with the current document", () {
			final nativeCookies = getNativeCookies();
			dom.document.cookie = "length1=foo";
			dom.document.cookie = "length2=bar";
			expect(Cookies().length, inInclusiveRange(nativeCookies.length, nativeCookies.length + 2));
		});
	});

	group(".onChanges", () {
		test("should trigger an event when a cookie is added", () {
			dom.document.cookie = "onChanges=; expires=Thu, 01 Jan 1970 00:00:00 GMT";

			final cookies = Cookies();
			cookies.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "onChanges");
				expect(record.currentValue, "foo");
				expect(record.previousValue, isNull);
			}));

			cookies["onChanges"] = "foo";
		});

		test("should trigger an event when a cookie is updated", () {
			dom.document.cookie = "onChanges=foo";

			final cookies = Cookies();
			cookies.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "onChanges");
				expect(record.currentValue, "bar");
				expect(record.previousValue, "foo");
			}));

			cookies["onChanges"] = "bar";
		});

		test("should trigger an event when a cookie is removed", () {
			dom.document.cookie = "onChanges=bar";

			final cookies = Cookies();
			cookies.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "onChanges");
				expect(record.currentValue, isNull);
				expect(record.previousValue, "bar");
			}));

			cookies.remove("onChanges");
		});

		test("should trigger an event when all the cookies are removed", () {
			dom.document.cookie = "onChanges1=foo";
			dom.document.cookie = "onChanges2=bar";

			final cookies = Cookies();
			cookies.onChanges.listen(expectAsync1((changes) {
				expect(changes.length, greaterThanOrEqualTo(2));

				var records = changes.entries.where((entry) => entry.key == "onChanges1").map((entry) => entry.value).toList();
				expect(records, hasLength(1));
				expect(records.first.currentValue, isNull);
				expect(records.first.previousValue, "foo");

				records = changes.entries.where((entry) => entry.key == "onChanges2").map((entry) => entry.value).toList();
				expect(records, hasLength(1));
				expect(records.first.currentValue, isNull);
				expect(records.first.previousValue, "bar");
			}));

			cookies.clear();
		});
	});

	group(".clear()", () {
		test("should remove all the cookies associated with the current document", () {
			dom.document.cookie = "clear1=foo";
			dom.document.cookie = "clear2=bar";

			Cookies().clear();
			expect(dom.document.cookie, isNot(contains("clear1")));
			expect(dom.document.cookie, isNot(contains("clear2")));
		});
	});

	group(".containsKey()", () {
		test("should return `false` if the current document has an associated cookie with the specified key", () {
			expect(Cookies().containsKey("foo"), isFalse);
		});

		test("should return `true` if the current document does not have an associated cookie with the specified key", () {
			dom.document.cookie = "has1=foo";
			dom.document.cookie = "has2=bar";

			final cookies = Cookies();
			expect(cookies.containsKey("has1"), isTrue);
			expect(cookies.containsKey("has2"), isTrue);
			expect(cookies.containsKey("foo"), isFalse);
			expect(cookies.containsKey("bar"), isFalse);
		});
	});

	group(".get()", () {
		test("should properly get the cookies associated with the current document", () {
			final cookies = Cookies();
			expect(cookies["foo"], isNull);

			dom.document.cookie = "get1=foo";
			expect(cookies["get1"], "foo");

			dom.document.cookie = "get2=123";
			expect(cookies["get2"], "123");
		});

		test("should return the given default value if the cookie is not found", () {
			final cookies = Cookies();
			expect(cookies["foo"], isNull);
			expect(cookies.get("foo", "bar"), "bar");
		});
	});

	group(".getObject()", () {
		test("should properly get the deserialized cookies associated with the current document", () {
			final cookies = Cookies();
			expect(cookies.getObject("foo"), isNull);

			dom.document.cookie = "getObject1=123";
			expect(cookies.getObject("getObject1"), 123);

			dom.document.cookie = "getObject2=%22bar%22";
			expect(cookies.getObject("getObject2"), "bar");

			dom.document.cookie = "getObject3=%7B%22key%22%3A%22value%22%7D";
			final object = cookies.getObject("getObject3");
			expect(object, allOf(isMap, hasLength(1)));
			expect(object["key"], "value");
		});

		test("should return a `null` reference if the value can't be deserialized", () {
			dom.document.cookie = "getObject4=bar";
			expect(Cookies().getObject("getObject4"), isNull);
		});

		test("should return the given default value if the cookie is not found", () {
			final cookies = Cookies();
			expect(cookies.getObject("foo"), isNull);
			expect(cookies.getObject("foo", {}), allOf(isMap, isEmpty));
		});
	});

	group(".putIfAbsent()", () {
		test("should add a new entry if it does not exist", () {
			final cookies = Cookies();
			expect(dom.document.cookie, isNot(contains("putIfAbsent1")));
			expect(cookies.putIfAbsent("putIfAbsent1", () => "foo"), "foo");
			expect(dom.document.cookie, contains("putIfAbsent1=foo"));
		});

		test("should not add a new entry if it already exists", () {
			final cookies = Cookies();
			dom.document.cookie = "putIfAbsent2=foo";
			expect(cookies.putIfAbsent("putIfAbsent2", () => "bar"), "foo");
			expect(dom.document.cookie, contains("putIfAbsent2=foo"));
		});
	});

	group(".putObjectIfAbsent()", () {
		test("should add a new entry if it does not exist", () {
			final cookies = Cookies();
			expect(dom.document.cookie, isNot(contains("putObjectIfAbsent1")));
			expect(cookies.putObjectIfAbsent("putObjectIfAbsent1", () => 123), 123);
			expect(dom.document.cookie, contains("putObjectIfAbsent1=123"));
		});

		test("should not add a new entry if it already exists", () {
			final cookies = Cookies();
			dom.document.cookie = "putObjectIfAbsent2=123";
			expect(cookies.putObjectIfAbsent("putObjectIfAbsent2", () => 456), 123);
			expect(dom.document.cookie, contains("putObjectIfAbsent2=123"));
		});
	});

	group(".remove()", () {
		test("should properly remove the cookies associated with the current document", () {
			dom.document.cookie = "remove1=foo";
			dom.document.cookie = "remove2=bar";

			final cookies = Cookies()..remove("remove1");
			expect(dom.document.cookie, isNot(contains("remove1")));
			expect(dom.document.cookie, contains("remove2=bar"));

			cookies.remove("remove2");
			expect(dom.document.cookie, isNot(contains("remove2")));
		});
	});

	group(".set()", () {
		test("should properly set the cookies associated with the current document", () {
			final cookies = Cookies();
			expect(dom.document.cookie, isNot(contains("set1")));
			expect(dom.document.cookie, isNot(contains("set2")));

			cookies["set1"] = "foo";
			expect(dom.document.cookie, contains("set1=foo"));
			expect(dom.document.cookie, isNot(contains("set2")));

			cookies["set2"] = "bar";
			expect(dom.document.cookie, contains("set1=foo"));
			expect(dom.document.cookie, contains("set2=bar"));

			cookies["set1"] = "123";
			expect(dom.document.cookie, contains("set1=123"));
			expect(dom.document.cookie, contains("set2=bar"));
		});
	});

	group(".setObject()", () {
		test("should properly serialize and set the cookies associated with the current document", () {
			final cookies = Cookies();
			expect(dom.document.cookie, isNot(contains("setObject1")));
			expect(dom.document.cookie, isNot(contains("setObject2")));

			cookies.setObject("setObject1", 123);
			expect(dom.document.cookie, contains("setObject1=123"));
			expect(dom.document.cookie, isNot(contains("setObject2")));

			cookies.setObject("setObject2", "foo");
			expect(dom.document.cookie, contains("setObject1=123"));
			expect(dom.document.cookie, contains("setObject2=%22foo%22"));

			cookies.setObject("setObject1", <String, String>{"key": "value"});
			expect(dom.document.cookie, contains("setObject1=%7B%22key%22%3A%22value%22%7D"));
			expect(dom.document.cookie, contains("setObject2=%22foo%22"));
		});
	});

	group(".toString()", () {
		test("should be the same value as the `document.cookie` property", () {
			expect(Cookies().toString(), dom.document.cookie);
		});
	});
});
