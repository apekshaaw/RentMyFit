import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/app/theme.dart';
import 'package:rent_my_fit/app/theme_notifier.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/cart/presentation/view model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view model/cart_view_model.dart';
import 'package:rent_my_fit/features/splash/presentation/view/splash_view.dart';
import 'package:rent_my_fit/features/home/presentation/view/admin_panel_view.dart';
import 'package:rent_my_fit/features/profile/presentation/view/profile_view.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/profile/presentation/view model/profile_event.dart';
import 'package:rent_my_fit/features/profile/presentation/view model/profile_view_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/wishlist/presentation/view_model/wishlist_view_model.dart';

// Global navigator key for dialogs/navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProductViewModel>(
              create: (_) =>
                  ProductViewModel(sl<ProductRepository>())..fetchProducts(),
            ),
            BlocProvider<WishlistViewModel>(
              create: (_) => WishlistViewModel(),
            ),
            BlocProvider<CartViewModel>(
              create: (_) => sl<CartViewModel>()..add(LoadCart()),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'RentMyFit',
            debugShowCheckedModeBanner: false,
            theme: getLightTheme(),
            darkTheme: getDarkTheme(),
            themeMode: themeMode,
            home: const SplashView(),
            routes: {
              '/login': (context) => const LoginView(),
              '/admin': (context) => const AdminPanelView(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/profile') {
                return PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black54,
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
              return null;
            },
          ),
        );
      },
    );
  }
}
