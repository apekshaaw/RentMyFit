import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/add_to_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/get_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:rent_my_fit/features/cart/domain/usecases/update_cart_quantity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartViewModel extends Bloc<CartEvent, CartState> {
  final AddToCart addToCartUseCase;
  final GetCart getCartUseCase;
  final RemoveFromCart removeFromCartUseCase;
  final UpdateCartQuantity updateCartQuantityUseCase;

  CartViewModel({
    required this.addToCartUseCase,
    required this.getCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartQuantityUseCase,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCartUseCase();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Failed to load cart.'));
    }
  }

  Future<void> _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
    try {
      await addToCartUseCase(event.item);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to add item.'));
    }
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) async {
    try {
      await removeFromCartUseCase(event.productId);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to remove item.'));
    }
  }

  Future<void> _onUpdateQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    try {
      await updateCartQuantityUseCase(event.productId, event.quantity);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to update quantity.'));
    }
  }
}
