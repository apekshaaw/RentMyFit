import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top abstract shape
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/top_wave.png',
              width: 180,
              errorBuilder: (context, error, stackTrace) {
                return const Text('❌ Failed to load top_wave.png');
              },
            ),
          ),

          // Bottom abstract wave
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/bottom_wave.png',
              width: 250,
              errorBuilder: (context, error, stackTrace) {
                return const Text('❌ Failed to load bottom_wave.png');
              },
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // RentMyFit logo with heart on "i"
                Image.asset(
                  'assets/rentmyfit_text_logo.png',
                  height: 45,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('❌ Failed to load rentmyfit_text_logo.png');
                  },
                ),

                const SizedBox(height: 12),

                const Text(
                  "Create your fashion\nin your own way",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 30),

                // Woman figure with "RF"
                Image.asset(
                  'assets/rf.png',
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('❌ Failed to load rf.png');
                  },
                ),

                const SizedBox(height: 40),

                // LOGIN button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "LOG IN",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                const SizedBox(height: 10),

                const Text("—  OR  —", style: TextStyle(fontWeight: FontWeight.w500)),

                const SizedBox(height: 10),

                // REGISTER button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFab1d79),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
