import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final viewModel = context.read<ProductViewModel>();
    final isFavorite = viewModel.isInWishlist(product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFFDEEF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEEF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? const Color(0xFFab1d79) : Colors.black,
            ),
            onPressed: () async {
              await viewModel.toggleWishlist(product.id);
              await viewModel.fetchWishlist();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(product.imageUrl, height: 200, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          product.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)} USD',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star_half, color: Colors.amber, size: 16),
                      Icon(Icons.star_border, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text("(4.5)", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Quantity:", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 14)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() => quantity++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("DESCRIPTION", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text("SELECT SIZE", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: product.sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSelected,
                        selectedColor: const Color(0xFFab1d79),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_bag),
                    onPressed: selectedSize != null && quantity > 0
    ? () {
        final cartViewModel = context.read<CartViewModel>();
        cartViewModel.add(AddToCart(product.id));
        Future.delayed(const Duration(milliseconds: 300), () {
          cartViewModel.add(FetchCart());
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Added to cart', style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(milliseconds: 600), () {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      }
    : null,


                    label: const Text("ADD TO CART"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFab1d79),
                      disabledBackgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
