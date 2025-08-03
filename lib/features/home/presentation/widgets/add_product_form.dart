import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_my_fit/core/network/image_url.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import '../view_model/product_view_model.dart';

class AddProductForm extends StatefulWidget {
  final ProductModel? existingProduct;

  const AddProductForm({super.key, this.existingProduct});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String _category;
  late List<String> _selectedSizes;
  File? _imageFile;
  String? _existingImageUrl;

  final clothingSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final shoeSizes = ['36', '37', '38', '39', '40', '41', '42', '43', '44'];

  @override
  void initState() {
    super.initState();

    final p = widget.existingProduct;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _category = p?.category ?? 'clothing';
    _selectedSizes = p?.sizes ?? ['M'];
    _existingImageUrl = p?.imageUrl;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _existingImageUrl = null;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() &&
        (_imageFile != null || _existingImageUrl != null) &&
        _selectedSizes.isNotEmpty) {
      final product = ProductModel(
        id: widget.existingProduct?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        sizes: _selectedSizes,
        imageUrl: _existingImageUrl ?? '',
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      );

      try {
        if (widget.existingProduct == null) {
          await context.read<ProductViewModel>().addProduct(product, _imageFile!);
        } else {
          await context.read<ProductViewModel>().updateProduct(product, _imageFile);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save product: ${e.toString()}")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select at least one size")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShoe = _category == 'shoes';
    final currentSizes = isShoe ? shoeSizes : clothingSizes;
    final isEditMode = widget.existingProduct != null;

    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFE3F2FD),
      title: Text(
        isEditMode ? 'Update Product' : 'Add Product',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: 560,
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_imageFile!,
                              height: 140, fit: BoxFit.cover),
                        )
                      : (_existingImageUrl != null &&
                              _existingImageUrl!.isNotEmpty)
                          // 🔥 Wrap this network image 🔥
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FutureBuilder<String>(
                                future:
                                    buildImageUrl(_existingImageUrl!),
                                builder: (ctx, snap) {
                                  if (!snap.hasData) {
                                    return const SizedBox(
                                      height: 140,
                                      child: Center(
                                          child:
                                              CircularProgressIndicator()),
                                    );
                                  }
                                  final url = snap.data!;
                                  debugPrint(
                                      '📷 Edit form image URL: $url');
                                  return Image.network(
                                    url,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (c, err, stack) {
                                      debugPrint(
                                          '⚠️ Edit image load error: $err');
                                      return const SizedBox(
                                        height: 140,
                                        child: Center(
                                            child: Icon(
                                                Icons
                                                    .broken_image,
                                                size: 48)),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'clothing', child: Text('Clothing')),
                    DropdownMenuItem(value: 'shoes', child: Text('Shoes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                      _selectedSizes.clear();
                    });
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Select Sizes', style: Theme.of(context).textTheme.labelMedium),
                ),
                Wrap(
                  spacing: 8,
                  children: currentSizes.map((size) {
                    final isSelected = _selectedSizes.contains(size);
                    return FilterChip(
                      label: Text(size),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSizes.add(size);
                          } else {
                            _selectedSizes.remove(size);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFab1d79),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          child: Text(isEditMode ? 'Update Product' : 'Add Product', style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
