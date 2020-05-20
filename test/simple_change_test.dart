import "package:biscuits/biscuits.dart";
import "package:test/test.dart";

/// Tests the features of the [SimpleChange] class.
void main() => group("SimpleChange", () {
	group(".fromJson()", () {
		test("should return an empty instance with an empty map", () {
			final change = SimpleChange.fromJson({});
			expect(change.currentValue, isNull);
			expect(change.previousValue, isNull);
		});

		test("should return an initialized instance with a non-empty map", () {
			final change = SimpleChange.fromJson({"currentValue": "foo", "previousValue": "bar"});
			expect(change.currentValue, "foo");
			expect(change.previousValue, "bar");
		});
	});

	group(".toJson()", () {
		test("should return a map with default values for a newly created instance", () {
			final map = const SimpleChange().toJson();
			expect(map, hasLength(2));
			expect(map["currentValue"], isNull);
			expect(map["previousValue"], isNull);
		});

		test("should return a non-empty map for an initialized instance", () {
			final map = const SimpleChange(currentValue: "bar", previousValue: "baz").toJson();
			expect(map, hasLength(2));
			expect(map["currentValue"], "bar");
			expect(map["previousValue"], "baz");
		});
	});
});
