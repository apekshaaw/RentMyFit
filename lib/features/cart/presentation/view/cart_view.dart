import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_state.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';
import '../../data/models/cart_item_model.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFab1d79),
        centerTitle: true,
        automaticallyImplyLeading: false, // ✅ clean header
      ),

      body: BlocBuilder<CartViewModel, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is CartLoaded) {
            // ✅ If no items, show friendly message
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'No items added to cart.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            // ✅ Normal cart list
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final CartItem item = state.items[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDEEF5), // ✅ light pink background
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Text(
                                    "GEETA COLLECTION", // ✅ placeholder subtitle
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${item.price.toStringAsFixed(2)} USD",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Selector
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      context.read<CartViewModel>().add(
                                          UpdateCartQuantity(item.productId, item.quantity - 1));
                                    }
                                  },
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    context.read<CartViewModel>().add(
                                        UpdateCartQuantity(item.productId, item.quantity + 1));
                                  },
                                ),
                              ],
                            ),

                            // Remove (X) Button
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                context.read<CartViewModel>().add(RemoveFromCart(item.productId));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Checkout Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${state.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFab1d79),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: Implement checkout logic
                        },
                        child: const Text("Go to Checkout"),
                      ),
                    ],
                  ),
                )
              ],
            );
          } 
          else if (state is CartError) {
            // ✅ Fallback to same empty message
            return const Center(
              child: Text(
                'No items added to cart.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
