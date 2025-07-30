import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/home/presentation/widgets/add_product_form.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({super.key});

  void _openEditForm(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AddProductForm(existingProduct: product),
    );
  }

  void _confirmDelete(BuildContext context, ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await context.read<ProductViewModel>().deleteProduct(product.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFFab1d79))),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            final storage = FlutterSecureStorage();
            await storage.delete(key: 'token');
            Navigator.of(ctx).pop(); // close the dialog first
            // Use root context to navigate
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFFab1d79),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddProductForm(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductViewModel, List<ProductModel>>(
        builder: (context, products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.network(product.imageUrl, width: 60, fit: BoxFit.cover),
                  title: Text(product.name),
                  subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}\nCategory: ${product.category}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openEditForm(context, product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
