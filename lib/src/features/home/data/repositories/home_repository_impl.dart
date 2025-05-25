import 'package:youtube_inbackground_newversion/src/features/home/data/data_source/localDb/home_local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDb homeLocalDb;
  HomeRepositoryImpl({required this.homeLocalDb});
  @override
  void addToFavorite() {
    // TODO: implement addToFavorite
  }

  @override
  void removeFromFavorite() {
    // TODO: implement removeFromFavorite
  }
}
