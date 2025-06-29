import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/download/data/data_source/localDb/downloads_local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/download/data/repositories/download_repository_impl.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/usecases/download_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';

Future initDownloadDependencyInjections() async {
  // Register the DownloadController as a permanent dependency
  // This means it will not be removed from memory until the app is closed
  // and can be accessed throughout the app.
  // This is useful for controllers that manage state or perform actions
  // that need to be available for the lifetime of the app.
  // It is a good practice to use Get.put() for controllers that are used
  // across multiple screens or need to maintain state.
  // This allows the controller to be accessed using Get.find<DownloadController>()
  // from anywhere in the app without needing to pass it around.
  final DownloadsLocalDb downloadsLocalDb = DownloadsLocalDb();
  final DownloadRepositoryImpl downloadRepository =
      DownloadRepositoryImpl(downloadsLocalDb: downloadsLocalDb);
  final DownloadUseCase downloadUseCase =
      DownloadUseCase(downloadRepository: downloadRepository);
  Get.put(DownloadController(downloadUseCase: downloadUseCase),
      permanent: true);
}
