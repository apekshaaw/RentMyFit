import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';
import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/auth/data/repository/user_remote_repository_impl.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';
import 'package:rent_my_fit/features/cart/domain/repository/cart_repository_impl.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/cart/data/data_source/cart_remote_data_source.dart';
import 'package:rent_my_fit/features/cart/domain/repository/cart_repository.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/get_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/add_to_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_view_model.dart';

final sl = GetIt.instance;
String? authToken;

Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasource(Hive.box<UserHiveModel>('userBox')),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRemoteRepositoryImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<LoginUser>(
    () => LoginUser(sl<UserRepository>()),
  );
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<UserRepository>()),
  );
  sl.registerFactory<LoginViewModel>(
    () => LoginViewModel(sl<LoginUser>()),
  );
  sl.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(sl<RegisterUser>()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );
  sl.registerFactory<ProductViewModel>(
    () => ProductViewModel(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCart>(
    () => GetCart(sl<CartRepository>()),
  );
  sl.registerLazySingleton<AddToCart>(
    () => AddToCart(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveFromCart>(
    () => RemoveFromCart(sl<CartRepository>()),
  );
  sl.registerLazySingleton<UpdateCartQuantity>(
    () => UpdateCartQuantity(sl<CartRepository>()),
  );
  sl.registerFactory<CartViewModel>(
    () => CartViewModel(
      getCartUseCase: sl<GetCart>(),
      addToCartUseCase: sl<AddToCart>(),
      removeFromCartUseCase: sl<RemoveFromCart>(),
      updateCartQuantityUseCase: sl<UpdateCartQuantity>(),
    ),
  );

  sl.registerLazySingleton<GetProfile>(
    () => GetProfile(sl<UserRepository>()),
  );
  sl.registerLazySingleton<UpdateProfile>(
    () => UpdateProfile(sl<UserRepository>()),
  );
  sl.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(sl<GetProfile>(), sl<UpdateProfile>()),
  );
}
