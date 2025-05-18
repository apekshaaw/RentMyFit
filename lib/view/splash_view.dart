import 'package:flutter/material.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds and then go to LoginView
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/top_wave.png',
              width: 180,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Failed to load top_wave.png');
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/bottom_wave.png',
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
                  'assets/rentmyfit_text_logo.png',
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
                  'assets/rf.png',
                  height: 200, // 🔥 made bigger
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Failed to load rf.png');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
