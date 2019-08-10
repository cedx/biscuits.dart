part of '../biscuits.dart';

/// Represents the event parameter used for a change event.
@JsonSerializable()
class SimpleChange {

  /// Creates a new simple change.
  const SimpleChange({this.currentValue, this.previousValue});

  /// Creates a new simple change from the specified [map] in JSON format.
  factory SimpleChange.fromJson(Map<String, dynamic> map) => _$SimpleChangeFromJson(map);

  /// The current value, or a `null` reference if removed.
  @JsonKey()
  final String currentValue;

  /// The previous value, or a `null` reference if added.
  @JsonKey()
  final String previousValue;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$SimpleChangeToJson(this);
}
