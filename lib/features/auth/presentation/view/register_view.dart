import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';
import '../view/login_view.dart';

class RegisterView extends StatelessWidget {
  final bool isTest;
  const RegisterView({super.key, this.isTest = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterViewModel(sl<RegisterUser>()),
      child: RegisterContent(isTest: isTest),
    );
  }
}

class RegisterContent extends StatefulWidget {
  final bool isTest;
  const RegisterContent({super.key, this.isTest = false});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void handleRegister(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<RegisterViewModel>().add(
      RegisterButtonPressed(name: name, email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<RegisterViewModel, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User registered'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              if (!widget.isTest) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              }
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: SingleChildScrollView(
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
                  buildTextField("Your Name", nameController, Icons.person_outline),
                  const SizedBox(height: 20),
                  buildTextField("Email address", emailController, Icons.email_outlined),
                  const SizedBox(height: 20),
                  buildTextField("Password", passwordController, Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 20),
                  buildTextField("Confirm Password", confirmPasswordController, Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => handleRegister(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFab1d79),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("REGISTER", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (!widget.isTest) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginView()),
                          );
                        }
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
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          key: Key(label), // Helpful for testing
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
