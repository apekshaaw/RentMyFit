import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: const Color(0xFFab1d79),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductViewModel, List<ProductModel>>(
        builder: (context, products) {
          final viewModel = context.read<ProductViewModel>();
          final wishlistProducts = viewModel.getWishlistProducts();

          if (wishlistProducts.isEmpty) {
            return const Center(child: Text('Your wishlist is empty.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: wishlistProducts.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return _buildWishlistCard(context, product);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, ProductModel product) {
    final viewModel = context.read<ProductViewModel>();

    return StatefulBuilder(
      builder: (context, setState) {
        bool isFavorite = viewModel.isInWishlist(product.id);

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF3F3F3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
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
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () async {
                  await viewModel.toggleWishlist(product.id);
                  await viewModel.fetchWishlist(); // Ensures updated state

                  final updated = viewModel.isInWishlist(product.id);

                  setState(() {
                    isFavorite = updated;
                  });

                  // If removed, trigger rebuild via Bloc (if not already)
                  context.read<ProductViewModel>().emit([...context.read<ProductViewModel>().state]);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(updated
                          ? 'Added to wishlist'
                          : 'Removed from wishlist'),
                      backgroundColor: updated ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? const Color(0xFFab1d79) : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
