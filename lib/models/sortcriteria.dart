
import 'package:drift/drift.dart' hide JsonKey;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sortcriteria.freezed.dart';

@freezed
class SortCriteria with _$SortCriteria {
  factory SortCriteria({
    @Default(OrderingMode.asc) OrderingMode mode,
    @Default('id') String key,
  }) = _SortCriteria;
	
}
