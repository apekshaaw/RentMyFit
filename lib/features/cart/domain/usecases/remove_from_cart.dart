import '../repository/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;
  RemoveFromCart(this.repository);

  Future<void> call(String productId) => repository.removeFromCart(productId);
}
