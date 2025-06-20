import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/auth/data/repository/user_local_repository_impl.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';
import '../view/login_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterViewModel(UserLocalRepository(UserLocalDatasource())),
      child: const RegisterContent(),
    );
  }
}

class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleRegister(BuildContext context) {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  context.read<RegisterViewModel>().add(
        RegisterButtonPressed(
          name: name,
          email: email,
          password: password,
        ),
      );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: BlocListener<RegisterViewModel, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('User registered'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
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
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFab1d79),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Your Name"),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Your Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Email address"),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Password"),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Confirm Password"),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => handleRegister(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFab1d79),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "REGISTER",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Log in",
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
