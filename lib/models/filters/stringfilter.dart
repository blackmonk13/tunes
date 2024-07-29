part of 'filters.dart';

enum StringFilterType { contains, startsWith, endsWith }

@freezed
class StringFilter with _$StringFilter {
  factory StringFilter({
    required String searchString,
    @Default(StringFilterType.contains)
    StringFilterType type, // Contains, starts with, ends with
    @Default(false) bool include,
  }) = _StringFilter;

  factory StringFilter.fromJson(Map<String, dynamic> json) =>
      _$StringFilterFromJson(json);
}
