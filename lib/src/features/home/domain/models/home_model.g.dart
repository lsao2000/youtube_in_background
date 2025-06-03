// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      channelImageUrl: json["channelImageUrl"],
      description: json["description"],
      videoId: json['videoId'] as String,
      viewCount: json['viewCount'] as String,
      isLive: json['isLive'] as bool,
      channelName: json['channelName'] as String,
      videoDuration:
          Duration(microseconds: (json['videoDuration'] as num).toInt()),
      durationAsString: json['durationAsString'] as String,
      title: json['title'] as String,
      isFavorite: json['isFavorite'] as bool,
    )..isLoadingFavorite = json['isLoadingFavorite'] as bool;

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'viewCount': instance.viewCount,
      'videoDuration': instance.videoDuration.inMicroseconds,
      'channelName': instance.channelName,
      'isLive': instance.isLive,
      'durationAsString': instance.durationAsString,
      'isFavorite': instance.isFavorite,
      'isLoadingFavorite': instance.isLoadingFavorite,
    };
