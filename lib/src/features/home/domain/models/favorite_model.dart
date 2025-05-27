
import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final int? id;
  final String videoId;
  FavoriteModel({required this.id, required this.videoId});
  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}
