import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/app/theme.dart';
import 'package:rent_my_fit/app/theme_notifier.dart';
import 'package:rent_my_fit/sensors/shake_service.dart';
import 'package:rent_my_fit/sensors/proximity_service.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/splash/presentation/view/splash_view.dart';
import 'package:rent_my_fit/features/home/presentation/view/admin_panel_view.dart';
import 'package:rent_my_fit/features/profile/presentation/view/profile_view.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/get_profile.dart';
import 'package:rent_my_fit/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_event.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_view_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/wishlist/presentation/view_model/wishlist_view_model.dart';

// Global key to allow dialogs/navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ShakeService _shakeService;
  late final ProximityService _proximityService;

  @override
  void initState() {
    super.initState();

    // Start shake detection → show logout dialog
    _shakeService = ShakeService()
      ..start()
      ..onShake.listen((_) => _showLogoutDialog());

    // Start proximity detection → toggle dark/light mode
    _proximityService = ProximityService()
      ..start()
      ..onProximity.listen((isNear) {
        if (isNear) {
          themeNotifier.toggleTheme();
        }
      });
  }

  @override
  void dispose() {
    _shakeService.dispose();
    _proximityService.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      builder: (dctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFab1d79)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dctx).pop();
              Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (_) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

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
