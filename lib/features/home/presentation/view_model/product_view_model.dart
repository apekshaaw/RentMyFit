import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/data/repositories/product_repository.dart';

class ProductViewModel extends Cubit<List<ProductModel>> {
  final ProductRepository repository;

  ProductViewModel(this.repository) : super([]);

  Future<void> fetchProducts() async {
    final products = await repository.fetchProducts();
    emit(products);
  }

  Future<void> addProduct(ProductModel product, File imageFile) async {
    await repository.addProduct(product, imageFile);
    fetchProducts(); // Refresh product list
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    fetchProducts();
  }

  Future<void> updateProduct(ProductModel product, [File? newImage]) async {
    await repository.updateProduct(product, newImage);
    fetchProducts();
  }

  // ✅ Backend-connected wishlist state
  List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => _wishlist;

  // ✅ Expose just the IDs for easy UI checks
  Set<String> get wishlistIds => _wishlist.map((p) => p.id).toSet();

  Future<void> fetchWishlist() async {
    try {
      _wishlist = await repository.fetchWishlist();
    } catch (e) {
      _wishlist = [];
      print('Error fetching wishlist: $e');
    }
    emit(List<ProductModel>.from(state)..shuffle()); 
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      await repository.toggleWishlist(productId);
      await fetchWishlist(); // Refresh after toggle 
    } catch (e) {
      print('Error toggling wishlist: $e');
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  List<ProductModel> getWishlistProducts() {
    return _wishlist;
  }
}
