import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  AddToCart(this.productId);
}

class UpdateCartQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateCartQuantity(this.productId, this.quantity);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class ClearCart extends CartEvent {}
