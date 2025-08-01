import 'package:equatable/equatable.dart';
import 'package:rent_my_fit/features/cart/data/models/cart_item_model.dart';
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  CartLoaded(this.items)
      : total = items.fold(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );

  @override
  List<Object?> get props => [items, total];
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
  @override
  List<Object?> get props => [message];
}
