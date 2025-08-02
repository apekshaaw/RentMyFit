import '../entity/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class GetCart {
  final CartRepository repository;
  GetCart(this.repository);

  Future<List<CartItemEntity>> call() => repository.getCart();
}
