part of biscuits;

/// Represents the event parameter used for a cookie change event.
class KeyValueChange {

  /// Creates a new key-value change record.
  KeyValueChange(this.key, {this.currentValue, this.previousValue});

  /// The current value for the cookie, or a `null` reference if removed.
  final String currentValue;

  /// The cookie name.
  final String key;

  /// The previous value for the cookie, or a `null` reference if added.
  final String previousValue;

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => {
    'key': key,
    'currentValue': currentValue,
    'previousValue': previousValue
  };

  /// Returns a string representation of this object.
  @override
  String toString() => 'KeyValueChange ${json.encode(this)}';
}
