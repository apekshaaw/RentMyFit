import 'package:flutter/material.dart';
import 'package:rent_my_fit/features/home/presentation/widgets/add_product_form.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD PRODUCT"),
        backgroundColor: const Color(0xFFab1d79),
      ),
      body: const AddProductForm(),
    );
  }
}
