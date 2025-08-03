import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/domain/entity/cart_item_entity.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_state.dart';
import 'package:rent_my_fit/features/cart/presentation/view%20model/cart_view_model.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFab1d79),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CartViewModel, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cartItems = state.items;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemTile(item: item);
                    },
                  ),
                ),
                _CheckoutBar(total: state.totalPrice),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItemEntity item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.read<CartViewModel>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFfce7f3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFab1d79))),
                const Text('GEETA COLLECTION', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)} USD',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  if (item.quantity > 1) {
                    cartBloc.add(UpdateCartItemQuantity(productId: item.id, quantity: item.quantity - 1));
                  }
                },
              ),
              Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  cartBloc.add(UpdateCartItemQuantity(productId: item.id, quantity: item.quantity + 1));
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              cartBloc.add(RemoveItemFromCart(item.id));
            },
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double total;

  const _CheckoutBar({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement checkout logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFab1d79),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("GO TO CHECKOUT", style: TextStyle(color: Colors.white)),
              Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
