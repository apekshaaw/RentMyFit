import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/home/presentation/view/dashboard_view.dart';
import '../view/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(sl()),
      child: const LoginContent(),
    );
  }
}

class LoginContent extends StatefulWidget {
  final bool isTest;

  const LoginContent({super.key, this.isTest = false});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<LoginViewModel>().add(
          LoginButtonPressed(username: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are logged in'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                if (!widget.isTest) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardView(isAdmin: state.isAdmin),
                    ),
                  );
                }
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_back),
                const SizedBox(height: 20),
                const Center(
                  child: Text("WELCOME",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const Center(
                  child: Text("LOGIN",
                      style: TextStyle(fontSize: 20, color: Color(0xFFab1d79))),
                ),
                const SizedBox(height: 30),
                const Text("Email"),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Password"),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () => handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFab1d79),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("LOG IN",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterView()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Not registered yet? ",
                        children: [
                          TextSpan(
                            text: "Create an Account",
                            style: TextStyle(color: Color(0xFFab1d79)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
