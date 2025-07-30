import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/presentation/view/add_product_view.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';



class DashboardView extends StatelessWidget {
  final bool isAdmin;

  const DashboardView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductViewModel>()..fetchProducts(),
      child: DashboardContent(isAdmin: isAdmin),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final bool isAdmin;

  const DashboardContent({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD'),
        backgroundColor: const Color(0xFFab1d79),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(product);
              },
            ),
          );
        },
      ),
      floatingActionButton: isAdmin
    ? FloatingActionButton(
        backgroundColor: const Color(0xFFab1d79),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddProductView()),
          );
        },
      )
    : null,


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(color: Color(0x80123456), blurRadius: 10),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: const Color(0xFFab1d79),
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: (_) {},
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFF3F3F3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFab1d79),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 11),
                    ),
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
