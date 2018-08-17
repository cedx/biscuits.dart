part of '../biscuits.dart';

/// Represents the event parameter used for a change event.
class SimpleChange<T> {

  /// Creates a new simple change.
  const SimpleChange({this.currentValue, this.previousValue});

  /// Creates a new simple change from the specified [map] in JSON format.
  factory SimpleChange.fromJson(Map<String, dynamic> map) => SimpleChange<T>(
    currentValue: map['currentValue'] is T ? map['currentValue'] : null,
    previousValue: map['previousValue'] is T ? map['previousValue'] : null
  );

  /// The current value, or a `null` reference if removed.
  final T currentValue;

  /// The previous value, or a `null` reference if added.
  final T previousValue;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'currentValue': currentValue,
    'previousValue': previousValue
  };

  /// Returns a string representation of this object.
  @override
  String toString() => 'SimpleChange ${json.encode(this)}';
}
