import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:rent_my_fit/features/auth/data/repository/user_remote_repository_impl.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';

import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  const baseUrl = 'http://10.0.2.2:5000/api';

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRemoteRepositoryImpl(http.Client()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(baseUrl: baseUrl));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // ViewModels
  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(() => RegisterViewModel(sl()));
  sl.registerFactory(() => ProductViewModel(sl()));
}
