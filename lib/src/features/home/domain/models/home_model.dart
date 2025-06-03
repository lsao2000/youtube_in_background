import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {
  final String videoId;
  final String title;
  final String viewCount;
  final Duration videoDuration;
  final String channelName;
  final bool isLive;
  final String durationAsString;
  final String description;
  String channelImageUrl;
  bool isFavorite = false;
  bool isLoadingFavorite = false;

  HomeModel(
      {required this.videoId,
      required this.description,
      required this.viewCount,
      required this.isLive,
      required this.channelImageUrl,
      required this.channelName,
      required this.videoDuration,
      required this.durationAsString,
      required this.title,
      required this.isFavorite});
  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
