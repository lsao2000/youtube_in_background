import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/search/data/datasource/local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/search/data/repositories/search_repository_impl.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/usercases/get_search_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/search/presentation/getx/search_controller.dart';

void initSearchDependy() {
  final datasource = LocalDb();
  final respository = SearchRepositoryImpl(datasource);
  final getSearchUserCase = GetSearchUseCase(searchRepository: respository);
  Get.put(SearchBarController(getSearchUseCase: getSearchUserCase));
}
