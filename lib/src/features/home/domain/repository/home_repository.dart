import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';

abstract class HomeRepository {
  Future<Map<String, dynamic>> addToFavorite({required String videoId});
  Future<Map<String, dynamic>> removeFromFavorite({required String videoId});
  Future<Map<String, dynamic>> getAllFavorite();
}
