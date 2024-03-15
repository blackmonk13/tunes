// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errormsg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorMsgImpl _$$ErrorMsgImplFromJson(Map<String, dynamic> json) =>
    _$ErrorMsgImpl(
      code: json['code'] as String? ?? "0000",
      brief: json['brief'] as String? ?? "Unknown error",
      details: json['details'] as String?,
      solution: json['solution'] as String?,
    );

Map<String, dynamic> _$$ErrorMsgImplToJson(_$ErrorMsgImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'brief': instance.brief,
      'details': instance.details,
      'solution': instance.solution,
    };
