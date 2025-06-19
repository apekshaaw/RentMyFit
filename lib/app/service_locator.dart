import 'package:get_it/get_it.dart';
import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/auth/data/repository/user_local_repository_impl.dart';
import '../../features/auth/domain/repository/user_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserLocalRepository(UserLocalDatasource()),
  );
}
