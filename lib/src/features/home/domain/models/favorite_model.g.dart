// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: (json['favorite_id'] as num?)?.toInt(),
      videoId: json['video_id'] as String,
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'favorite_id': instance.id,
      'video_id': instance.videoId,
    };
