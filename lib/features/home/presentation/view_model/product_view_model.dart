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
  fetchProducts(); // Refresh list
}


  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    fetchProducts();
  }

  Future<void> updateProduct(ProductModel product, [File? newImage]) async {
  await repository.updateProduct(product, newImage);
  fetchProducts();
}

}
