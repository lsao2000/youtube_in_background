import 'package:youtube_inbackground_newversion/src/features/home/domain/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;
  HomeUseCase({required this.homeRepository});

  addToFavorite() {
    homeRepository.addToFavorite();
  }

  removeFromFavorite() {
    homeRepository.removeFromFavorite();
  }
}
