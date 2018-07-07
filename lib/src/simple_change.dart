part of biscuits;

/// Represents the event parameter used for a cookie change event.
class SimpleChange {

  /// Creates a new key-value change record.
  SimpleChange({this.currentValue, this.previousValue});

  /// The current value for the cookie, or a `null` reference if removed.
  final String currentValue;

  /// The previous value for the cookie, or a `null` reference if added.
  final String previousValue;

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => {
    'currentValue': currentValue,
    'previousValue': previousValue
  };

  /// Returns a string representation of this object.
  @override
  String toString() => 'SimpleChange ${json.encode(this)}';
}
