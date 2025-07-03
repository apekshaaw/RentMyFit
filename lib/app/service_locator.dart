import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/features/auth/data/repository/user_remote_repository_impl.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton<UserRepository>(
    () => UserRemoteRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
}
