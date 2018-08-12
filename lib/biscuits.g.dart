// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biscuits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookieOptions _$CookieOptionsFromJson(Map<String, dynamic> json) {
  return CookieOptions(
      domain: json['domain'] as String ?? '',
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
      path: json['path'] as String ?? '',
      secure: json['secure'] as bool ?? false);
}

Map<String, dynamic> _$CookieOptionsToJson(CookieOptions instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'expires': instance.expires?.toIso8601String(),
      'path': instance.path,
      'secure': instance.secure
    };

SimpleChange _$SimpleChangeFromJson(Map<String, dynamic> json) {
  return SimpleChange(
      currentValue: json['currentValue'] as String,
      previousValue: json['previousValue'] as String);
}

Map<String, dynamic> _$SimpleChangeToJson(SimpleChange instance) =>
    <String, dynamic>{
      'currentValue': instance.currentValue,
      'previousValue': instance.previousValue
    };
