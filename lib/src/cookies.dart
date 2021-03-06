part of "../biscuits.dart";

/// Provides access to the HTTP cookies.
/// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
class Cookies extends Object with MapMixin<String, String> { // ignore: prefer_mixin

	/// Creates a new cookie service.
	Cookies({CookieOptions defaults, dom.Document htmlDocument}):
		defaults = defaults ?? CookieOptions(),
		_document = htmlDocument ?? dom.document;

	/// The underlying HTML document.
	final dom.Document _document;

	/// The handler of "changes" events.
	final StreamController<Map<String, SimpleChange>> _onChanges = StreamController<Map<String, SimpleChange>>.broadcast();

	/// The default cookie options.
	final CookieOptions defaults;

	/// The keys of the cookies associated with the current document.
	@override
	Iterable<String> get keys {
		final keys = _document.cookie.replaceAll(RegExp(r"((?:^|\s*;)[^=]+)(?=;|$)|^\s*|\s*(?:=[^;]*)?(?:\1|$)"), "");
		return keys.isNotEmpty ? keys.split(RegExp(r"\s*(?:=[^;]*)?;\s*")).map(Uri.decodeComponent) : <String>[];
	}

	/// The stream of "changes" events.
	Stream<Map<String, SimpleChange>> get onChanges => _onChanges.stream;

	/// Gets the value associated to the specified [key].
	@override
	String operator [](Object key) => get(key);

	/// Associates the [key] with the given [value].
	@override
	void operator []=(String key, String value) => set(key, value);

	/// Removes all cookies associated with the current document.
	@override
	void clear() {
		final changes = <String, SimpleChange>{};
		for (final key in keys) {
			changes[key] = SimpleChange(previousValue: this[key]);
			_removeItem(key);
		}

		_onChanges.add(changes);
	}

	/// Gets a value indicating whether the current document has a cookie with the specified [key].
	@override
	bool containsKey(Object key) {
		assert(key is String && key.isNotEmpty);
		final token = Uri.encodeComponent(key).replaceAll(RegExp("[-.+*]"), r"\$&");
		return RegExp("(?:^|;\\s*)$token\\s*=").hasMatch(_document.cookie);
	}

	/// Gets the value associated to the specified [key].
	/// Returns the given [defaultValue] if the cookie does not exist.
	String get(String key, [String defaultValue]) {
		if (!containsKey(key)) return defaultValue;

		try {
			final token = Uri.encodeComponent(key).replaceAll(RegExp("[-.+*]"), r"\$&");
			final scanner = RegExp("(?:(?:^|.*;)\\s*$token\\s*=\\s*([^;]*).*\$)|^.*\$");
			return Uri.decodeComponent(_document.cookie.replaceAllMapped(scanner, (match) => match[1]));
		}

		on Exception {
			return defaultValue;
		}
	}

	/// Gets the deserialized value associated to the specified [key].
	/// Returns the given [defaultValue] if the cookie does not exist.
	dynamic getObject(String key, [defaultValue]) {
		try {
			final value = this[key];
			return value is String ? jsonDecode(value) : defaultValue;
		}

		on FormatException {
			return defaultValue;
		}
	}

	/// Looks up the cookie with the specified [key], or add a new cookie if it isn't there.
	///
	/// Returns the value associated to [key], if there is one. Otherwise calls [ifAbsent] to get a new value,
	/// associates [key] to that value, and then returns the new value.
	@override
	String putIfAbsent(String key, String Function() ifAbsent, [CookieOptions options]) {
		if (!containsKey(key)) set(key, ifAbsent(), options);
		return this[key];
	}

	/// Looks up the cookie with the specified [key], or add a new cookie if it isn't there.
	///
	/// Returns the deserialized value associated to [key], if there is one. Otherwise calls [ifAbsent] to get a new value,
	/// serializes and associates [key] to that value, and then returns the new value.
	dynamic putObjectIfAbsent(String key, dynamic Function() ifAbsent, [CookieOptions options]) {
		if (!containsKey(key)) setObject(key, ifAbsent(), options);
		return getObject(key);
	}

	/// Removes the cookie with the specified [key] and its associated value.
	/// Returns the value associated with [key] before it was removed.
	@override
	String remove(Object key, [CookieOptions options]) {
		assert(key is String && key.isNotEmpty);

		final previousValue = this[key];
		_removeItem(key, options);
		_onChanges.add(<String, SimpleChange>{
			key: SimpleChange(previousValue: previousValue)
		});

		return previousValue;
	}

	/// Associates a given [value] to the specified [key].
	void set(String key, String value, [CookieOptions options]) {
		assert(key.isNotEmpty);

		final cookieOptions = _getOptions(options).toString();
		var cookieValue = "${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}";
		if (cookieOptions.isNotEmpty) cookieValue += "; $cookieOptions";

		final previousValue = this[key];
		_document.cookie = cookieValue;
		_onChanges.add(<String, SimpleChange>{
			key: SimpleChange(currentValue: value, previousValue: previousValue)
		});
	}

	/// Serializes and associates a given [value] to the specified [key].
	void setObject(String key, value, [CookieOptions options]) => set(key, jsonEncode(value), options);

	/// Returns a string representation of this object.
	@override
	String toString() => _document.cookie;

	/// Merges the default cookie options with the specified ones.
	CookieOptions _getOptions([CookieOptions options]) {
		options ??= CookieOptions();
		return CookieOptions(
			domain: options.domain.isNotEmpty ? options.domain : defaults.domain,
			expires: options.expires ?? defaults.expires,
			path: options.path.isNotEmpty ? options.path : defaults.path,
			secure: options.secure ? options.secure : defaults.secure
		);
	}

	/// Removes the value associated to the specified [key].
	void _removeItem(String key, [CookieOptions options]) {
		if (!containsKey(key)) return;
		final cookieOptions = _getOptions(options)..expires = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
		_document.cookie = "${Uri.encodeComponent(key)}=; $cookieOptions";
	}
}
