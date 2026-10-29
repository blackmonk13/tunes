part of 'filters.dart';

enum SizeOperator {
  greaterThan,
  lessThan,
  equalTo,
  range,
}

@freezed
class SizeFilter with _$SizeFilter {
  factory SizeFilter({
    int? sizeBytes,
    int? minSizeBytes,
    int? maxSizeBytes,
    @Default(SizeOperator.lessThan) SizeOperator operator,
  }) = _SizeFilter;

  factory SizeFilter.fromJson(Map<String, dynamic> json) =>
      _$SizeFilterFromJson(json);
}
