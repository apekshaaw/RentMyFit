import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFFab1d79),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: const SizedBox(), 
    );
  }
}
