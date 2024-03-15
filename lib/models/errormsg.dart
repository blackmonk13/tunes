import 'package:freezed_annotation/freezed_annotation.dart';

part 'errormsg.freezed.dart';
part 'errormsg.g.dart';

@freezed
class ErrorMsg with _$ErrorMsg {
  factory ErrorMsg({
    @Default("0000") String code,
    @Default("Unknown error") String brief,
    String? details,
    String? solution,
  }) = _ErrorMsg;

  factory ErrorMsg.fromJson(Map<String, dynamic> json) =>
      _$ErrorMsgFromJson(json);
}
