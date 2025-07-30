import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/splash/presentation/view/splash_view.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductViewModel>(
      create: (_) => ProductViewModel(sl<ProductRepository>())..fetchProducts(),
      child: MaterialApp(
        title: 'RentMyFit',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: const SplashView(), // Or SplashView() if needed
      ),
    );
  }
}
