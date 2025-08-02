import 'package:rent_my_fit/features/cart/data/data_source/cart_remote_data_source.dart';

import '../../domain/entity/cart_item_entity.dart';
import '../../domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addToCart(CartItemEntity item) {
    return remoteDataSource.addToCart(item);
  }

  @override
  Future<List<CartItemEntity>> getCart() {
    return remoteDataSource.getCart();
  }

  @override
  Future<void> removeFromCart(String productId) {
    return remoteDataSource.removeFromCart(productId);
  }

  @override
  Future<void> updateCartItem(String productId, int quantity) {
    return remoteDataSource.updateCartItem(productId, quantity);
  }
}
