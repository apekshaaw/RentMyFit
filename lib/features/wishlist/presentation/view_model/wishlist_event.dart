part of 'wishlist_view_model.dart';

abstract class WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final ProductModel product;

  ToggleWishlist(this.product);
}
