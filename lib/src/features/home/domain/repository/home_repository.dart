abstract class HomeRepository {
  Future<Map<String, dynamic>> addToFavorite({required String videoId});
  Future<Map<String, dynamic>> removeFromFavorite({required int favoriteId});
}
