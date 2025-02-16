import 'package:flutmisho/data/repository/all_items_repository_impl.dart';
import 'package:flutmisho/data/service/items_service.dart';
import 'package:flutmisho/domain/repository/all_items_repository.dart';
import 'package:flutmisho/domain/usecase/items_use_case.dart';
import 'package:flutmisho/ui/viewmodel/all_items_view_model.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setup() {
  // Service layer
  sl.registerLazySingleton<MishosService>(() => MishosService());

  // Repository layer
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl<MishosService>()));

  // Domain layer
  sl.registerLazySingleton<MishoUseCaseAll>(
      () => MishoUseCaseAll(sl<UserRepository>()));

  // ViewModel
  sl.registerFactory<MishoViewModel>(
      () => MishoViewModel(useCase: sl<MishoUseCaseAll>()));
}
