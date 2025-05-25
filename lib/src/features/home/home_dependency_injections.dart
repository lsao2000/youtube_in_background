import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/home/data/data_source/localDb/home_local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';

initHomeDependency() async {
  final HomeLocalDb homeLocalDb = HomeLocalDb();
  final HomeRepositoryImpl homeRepositoryImpl =
      HomeRepositoryImpl(homeLocalDb: homeLocalDb);
  final HomeUseCase homeUseCase =
      HomeUseCase(homeRepository: homeRepositoryImpl);
  Get.put(HomeController(homeUseCase: homeUseCase));
}
