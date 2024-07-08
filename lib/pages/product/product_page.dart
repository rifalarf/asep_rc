import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../model/product.dart';
import 'add_product_page.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late StreamController<List<Product>> _productStreamController;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _productStreamController = StreamController<List<Product>>.broadcast();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('https://api.kartel.dev/products'));

    if (response.statusCode == 200) {
      _products = Product.fromJsonList(response.body);
      _productStreamController.add(_products);
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _addProduct(Product newProduct) {
    setState(() {
      _products.add(newProduct);
      _productStreamController.add(_products);
    });
  }

  void _removeProduct(String id) {
    setState(() {
      _products.removeWhere((product) => product.id == id);
      _productStreamController.add(_products);
    });
  }

  void _updateProduct(Product updatedProduct) {
    setState(() {
      final index = _products.indexWhere((product) => product.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        _productStreamController.add(_products);
      }
    });
  }

  @override
  void dispose() {
    _productStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                    if (result == true) {
                      _removeProduct(product.id);
                    } else if (result == false) {
                      _fetchProducts();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: ${product.price}, Qty: ${product.qty}, Issuer: ${product.issuer}'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newProduct = await Navigator.push<Product>(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
          if (newProduct != null) {
            _addProduct(newProduct);
          }
        },
        label: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF758694),
      ),
    );
  }
}