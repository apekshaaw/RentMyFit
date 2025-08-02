import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/domain/entity/cart_item_entity.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // Grab the one-and-only CartViewModel provided at the top of the Dashboard
    final cartBloc = context.read<CartViewModel>();

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
          // (You had a wishlist button here; leave it as-is if you wish)
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
                  // --- Product title & price ---
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

                  // --- Rating placeholder ---
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

                  // --- Quantity selector ---
                  Row(
                    children: [
                      const Text("Quantity:", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) setState(() => quantity--);
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

                  // --- Description ---
                  const Text("DESCRIPTION", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // --- Size selector ---
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

                  // --- ADD TO CART button (updated) ---
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_bag),
                    onPressed: selectedSize != null && quantity > 0
                        ? () {
                            // 1️⃣ Add the item
                            final cartItem = CartItemEntity(
                              id: product.id,
                              name: product.name,
                              imageUrl: product.imageUrl,
                              price: product.price,
                              size: selectedSize!,
                              quantity: quantity,
                            );
                            cartBloc.add(AddItemToCart(cartItem));

                            // 2️⃣ Immediately reload the cart contents
                            cartBloc.add(LoadCart());

                            // 3️⃣ Feedback & navigate back home
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
