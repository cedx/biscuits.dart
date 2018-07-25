part of biscuits;

/// Represents the event parameter used for a cookie change event.
@JsonSerializable()
class SimpleChange {

  /// Creates a new simple change.
  const SimpleChange({this.currentValue, this.previousValue});

  /// Creates a new simple change from the specified [map] in JSON format.
  factory SimpleChange.fromJson(Map<String, dynamic> map) => _$SimpleChangeFromJson(map);

  /// The current value for the cookie, or a `null` reference if removed.
  final String currentValue;

  /// The previous value for the cookie, or a `null` reference if added.
  final String previousValue;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$SimpleChangeToJson(this);

  /// Returns a string representation of this object.
  @override
  String toString() => 'SimpleChange ${json.encode(this)}';
}
