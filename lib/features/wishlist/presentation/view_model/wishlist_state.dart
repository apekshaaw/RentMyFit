part of 'wishlist_view_model.dart';

abstract class WishlistState {
  final List<ProductModel> wishlist;

  const WishlistState({this.wishlist = const []});
}

class WishlistInitial extends WishlistState {
  const WishlistInitial() : super();
}

class WishlistUpdated extends WishlistState {
  const WishlistUpdated({required List<ProductModel> wishlist}) : super(wishlist: wishlist);
}
