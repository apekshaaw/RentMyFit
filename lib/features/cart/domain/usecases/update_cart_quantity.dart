import '../repository/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;
  UpdateCartQuantity(this.repository);

  Future<void> call(String productId, int quantity) =>
      repository.updateCartItem(productId, quantity);
}
