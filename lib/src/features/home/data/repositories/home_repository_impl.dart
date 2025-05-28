import 'package:sqflite/sqflite.dart';
import 'package:youtube_inbackground_newversion/src/features/home/data/data_source/localDb/home_local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDb homeLocalDb;
  HomeRepositoryImpl({required this.homeLocalDb});
  @override
  Future<Map<String, dynamic>> addToFavorite({required String videoId}) async {
    try {
      homeLocalDb.addToFavorite(videoId: videoId);
      return {"success": true, "msg": "sucess to add favorite to table"};
    } catch (e) {
      return {"success": false, "msg": e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAllFavorite() async {
    try {
      // return
      var data = await homeLocalDb.getAllFavorites();
      return {"success": true, "msg": "success to retrieve data", "data": data};
    } catch (e) {
      return {"success": false, "msg": e.toString(), "data": []};
    }
  }

  @override
  Future<Map<String, dynamic>> removeFromFavorite(
      {required String? videoId}) async {
    try {
      homeLocalDb.deleteFavoriteHistory(videoId: videoId);
      return {"success": true, "msg": "success to delete favorite"};
    } on DatabaseException catch (e) {
      return {"success": true, "msg": e.toString()};
    }
  }
}
