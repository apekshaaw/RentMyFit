import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/app/theme.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_event.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_view_model.dart';
import 'package:rent_my_fit/features/splash/presentation/view/splash_view.dart';
import 'package:rent_my_fit/features/home/presentation/view/admin_panel_view.dart';
import 'package:rent_my_fit/features/profile/presentation/view/profile_view.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/wishlist/presentation/view_model/wishlist_view_model.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Products
        BlocProvider<ProductViewModel>(
          create: (_) => ProductViewModel(sl<ProductRepository>())..fetchProducts(),
        ),

        // Wishlist
        BlocProvider<WishlistViewModel>(
          create: (_) => WishlistViewModel(),
        ),

        // Cart
        BlocProvider<CartViewModel>(
          create: (_) => sl<CartViewModel>()..add(FetchCart()),
        ),
      ],
      child: MaterialApp(
        title: 'RentMyFit',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),

        // Your default screens
        home: const SplashView(),
        routes: {
          '/login': (context) => const LoginView(),
          '/admin': (context) => const AdminPanelView(),
          // NOTE: we remove '/profile' from here so onGenerateRoute can catch it
        },

        // Handle /profile with a transparent route
        onGenerateRoute: (settings) {
          if (settings.name == '/profile') {
            return PageRouteBuilder(
              opaque: false,            // allows backdrop to show
              barrierColor: Colors.black54, // matches your drawer backdrop
              pageBuilder: (_, __, ___) => BlocProvider<ProfileViewModel>(
                create: (_) {
                  final vm = ProfileViewModel(
                    sl<GetProfile>(),
                    sl<UpdateProfile>(),
                  );
                  vm.add(LoadProfile());
                  return vm;
                },
                child: const ProfileView(),
              ),
            );
          }
          return null; // fall back to routes{}
        },
      ),
    );
  }
}
