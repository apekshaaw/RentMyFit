import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistViewModel extends Bloc<WishlistEvent, WishlistState> {
  WishlistViewModel() : super(WishlistInitial()) {
    on<ToggleWishlist>((event, emit) {
      // Start with empty list or copy from existing state
      List<ProductModel> currentList = [];

      if (state is WishlistUpdated) {
        currentList = List<ProductModel>.from((state as WishlistUpdated).wishlist);
      }

      // Toggle logic
      final alreadyAdded = currentList.any((item) => item.id == event.product.id);

      if (alreadyAdded) {
        currentList.removeWhere((item) => item.id == event.product.id);
      } else {
        currentList.add(event.product);
      }

      emit(WishlistUpdated(wishlist: currentList));
    });
  }
}
