part of 'filters.dart';

@freezed
class PathFilter with _$PathFilter {
  factory PathFilter({
    required String path,
    // TODO: set to exclude
    @Default(false) bool include,
    @Default(true) bool enabled,
  }) = _PathFilter;

  factory PathFilter.fromJson(Map<String, dynamic> json) =>
      _$PathFilterFromJson(json);
}
