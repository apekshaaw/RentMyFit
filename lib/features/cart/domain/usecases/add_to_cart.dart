import '../entity/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class AddToCart {
  final CartRepository repository;
  AddToCart(this.repository);

  Future<void> call(CartItemEntity item) => repository.addToCart(item);
}
