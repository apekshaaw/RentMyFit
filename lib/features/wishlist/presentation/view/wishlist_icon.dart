import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/wishlist/presentation/view_model/wishlist_view_model.dart';

class WishlistIcon extends StatelessWidget {
  final ProductModel product;

  const WishlistIcon({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistViewModel, WishlistState>(
      builder: (context, state) {
        final isWishlisted = state.wishlist.any((item) => item.id == product.id);
        return IconButton(
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted ? Colors.pink : Colors.black,
          ),
          onPressed: () {
            context.read<WishlistViewModel>().add(ToggleWishlist(product));
          },
        );
      },
    );
  }
}
