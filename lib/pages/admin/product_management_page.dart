import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isEditing = false;
  String? _editingProductId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    _categoryController.clear();
    setState(() {
      _isEditing = false;
      _editingProductId = null;
    });
  }

  void _editProduct(Product product) {
    setState(() {
      _isEditing = true;
      _editingProductId = product.id;
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _imageUrlController.text = product.imageUrl;
      _categoryController.text = product.category;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = context.read<ProductProvider>();
    final product = Product(
      id: _editingProductId ?? DateTime.now().toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      category: _categoryController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (_isEditing) {
        await productProvider.updateProduct(product);
      } else {
        await productProvider.addProduct(product);
      }
      _resetForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Product updated' : 'Product added'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Management',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.add),
                label: const Text('Add New Product'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? 'Edit Product' : 'Add New Product',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Product Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a product name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(),
                                prefixText: '\$',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _imageUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an image URL';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a category';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_isEditing)
                                  TextButton(
                                    onPressed: _resetForm,
                                    child: const Text('Cancel'),
                                  ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: Text(_isEditing ? 'Update' : 'Add'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product List',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Consumer<ProductProvider>(
                              builder: (context, productProvider, child) {
                                if (productProvider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (productProvider.error != null) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 48,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          productProvider.error!,
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            productProvider.clearError();
                                            productProvider.fetchProducts();
                                          },
                                          child: const Text('Try Again'),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final products = productProvider.products;
                                if (products.isEmpty) {
                                  return const Center(
                                    child: Text('No products found'),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return ListTile(
                                      leading: Image.network(
                                        product.imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                      title: Text(product.name),
                                      subtitle: Text(
                                        '\$${product.price.toStringAsFixed(2)} - ${product.category}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () => _editProduct(product),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Delete Product'),
                                                  content: const Text(
                                                    'Are you sure you want to delete this product?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmed == true) {
                                                try {
                                                  await productProvider.deleteProduct(product.id);
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Product deleted'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Error: ${e.toString()}'),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
