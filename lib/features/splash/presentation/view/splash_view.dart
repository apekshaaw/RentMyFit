import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/splash/presentation/view_model/splash_event.dart';
import 'package:rent_my_fit/features/splash/presentation/view_model/splash_state.dart';
import 'package:rent_my_fit/features/splash/presentation/view_model/splash_view_model.dart';
import '../../../auth/presentation/view/login_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashViewModel()..add(StartSplash()),
      child: const SplashContent(),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/top_wave.png',
                width: 180,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Failed to load top_wave.png');
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/bottom_wave.png',
                width: 250,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Failed to load bottom_wave.png');
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/rentmyfit_text_logo.png',
                    height: 45,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load rentmyfit_text_logo.png');
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Create your fashion\nin your own way",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/rf.png',
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load rf.png');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
