import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/cart/data/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartViewModel extends Bloc<CartEvent, CartState> {
  final String baseUrl;
  final String token;

  CartViewModel({required this.baseUrl, required this.token})
    : super(CartLoading()) {
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartQuantity>(_onUpdateQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
  emit(CartLoading());
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Cart fetch status: ${response.statusCode}');
    print('Cart fetch body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        // If backend returns a list
        final items = data.map((item) => CartItem.fromJson(item)).toList();
        emit(CartLoaded(items));
      } else if (data is Map && data['cart'] != null) {
        // If backend returns an object with "cart" key
        final items = (data['cart'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
        emit(CartLoaded(items));
      } else {
        print('Unexpected cart format: $data');
        emit(CartLoaded([])); // fallback to empty cart
      }
    } else {
      emit(CartError('Failed to load cart: ${response.statusCode}'));
    }
  } catch (e) {
    emit(CartError(e.toString()));
  }
}


  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'productId': event.productId}),
    );

    print('AddToCart status: ${response.statusCode}');
    print('AddToCart body: ${response.body}');

    // Trigger cart refresh after adding
    add(FetchCart());
  } catch (e) {
    emit(CartError(e.toString()));
  }
}


  Future<void> _onUpdateQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await http.patch(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': event.productId,
          'quantity': event.quantity,
        }),
      );
      add(FetchCart());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/cart/${event.productId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      add(FetchCart());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/cart'),
        headers: {'Authorization': 'Bearer $token'},
      );
      add(FetchCart());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
