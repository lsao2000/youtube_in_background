import 'package:json_annotation/json_annotation.dart';

part 'search_history.g.dart';

@JsonSerializable()
class SearchHistory {
  @JsonKey(includeIfNull: false)
  final int? _id;
  final String _title;
  SearchHistory({required String title, int? id})
      : _id = id,
        _title = title;
  int? get getId => _id;
  String get getTitle => _title;
  // factory SearchHistory.fromJson(Map<String, dynamic> json) =>
  //     _$SearchHistory(json);
  // toJson() => _$SearchHistory(this);
  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  // Required for JSON deserialization
  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);
}
