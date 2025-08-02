import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/core/network/api_base_url.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';

import 'package:rent_my_fit/features/auth/data/repository/user_remote_repository_impl.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';

import 'package:rent_my_fit/features/cart/data/data_source/cart_remote_data_source.dart';
import 'package:rent_my_fit/features/cart/domain/repository/cart_repository.dart';
import 'package:rent_my_fit/features/cart/domain/repository/cart_repository_impl.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/add_to_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/get_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:rent_my_fit/features/cart/presentation/view model/cart_view_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';

import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/profile/presentation/view model/profile_view_model.dart';

import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';

final sl = GetIt.instance;

String? authToken;

Future<void> init() async {
  final baseUrl = getBaseUrl();


  // 🧠 Auth
  sl.registerLazySingleton<UserRepository>(
    () => UserRemoteRepositoryImpl(http.Client()),
  );
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(() => RegisterViewModel(sl()));

  // 🏠 Home/Product
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(baseUrl: baseUrl),
  );
  sl.registerFactory(() => ProductViewModel(sl()));

  // 👤 Profile
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerFactory(() => ProfileViewModel(sl(), sl()));

  // 📦 Cart
  sl.registerLazySingleton(() => UserLocalDatasource(Hive.box<UserHiveModel>('userBox')));
 // needed for token

  sl.registerLazySingleton(() => CartRemoteDataSource());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantity(sl()));

  sl.registerFactory(
    () => CartViewModel(
      addToCartUseCase: sl(),
      getCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      updateCartQuantityUseCase: sl(),
    ),
  );
}
