part of 'filters.dart';

enum DurationOperator {
  greaterThan,
  lessThan,
  equalTo,
  range,
}

@freezed
class DurationFilter with _$DurationFilter {
  factory DurationFilter({
    Duration? singleDuration,
    Duration? minDuration,
    Duration? maxDuration,
    @Default(DurationOperator.equalTo) DurationOperator operator,
  }) = _DurationFilter;

  factory DurationFilter.fromJson(Map<String, dynamic> json) =>
      _$DurationFilterFromJson(json);
}
