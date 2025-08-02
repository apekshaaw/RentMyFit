import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:rent_my_fit/features/auth/data/repository/user_remote_repository_impl.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_view_model.dart';


final sl = GetIt.instance;

String? authToken;

Future<void> init() async {
  const baseUrl = 'http://10.0.2.2:5000/api';

  sl.registerLazySingleton<UserRepository>(() => UserRemoteRepositoryImpl(http.Client()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(baseUrl: baseUrl));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(() => RegisterViewModel(sl()));
  sl.registerFactory(() => ProductViewModel(sl()));

  sl.registerFactory(
  () => ProfileViewModel(
    sl<GetProfile>(),
    sl<UpdateProfile>(),
  ),
);

  sl.registerLazySingleton(() => CartViewModel(
        baseUrl: "$baseUrl/auth", 
        token: authToken ?? "",
      ));
      
}
