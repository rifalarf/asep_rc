import 'package:asep_rc/model/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'stock/add_stock_page.dart';
import 'stock/stock_detail_page.dart';
import 'info_page.dart';
import 'product/product_page.dart';
import 'sales/sales_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamController<List<Stock>> _stockStreamController;
  List<Stock> _stocks = [];

  @override
  void initState() {
    super.initState();
    _stockStreamController = StreamController<List<Stock>>.broadcast();
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    final response = await http.get(Uri.parse('https://api.kartel.dev/stocks'));

    if (response.statusCode == 200) {
      _stocks = Stock.fromJsonList(response.body);
      _stockStreamController.add(_stocks);
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  void _addStock(Stock newStock) {
    setState(() {
      _stocks.add(newStock);
      _stockStreamController.add(_stocks);
      print('Stock added: $newStock');
    });
  }

  void _removeStock(String id) {
    setState(() {
      _stocks.removeWhere((stock) => stock.id == id);
      _stockStreamController.add(_stocks);
      print('Stock removed: $id');
    });
  }

  void _updateStock(Stock updatedStock) {
    setState(() {
      final index = _stocks.indexWhere((stock) => stock.id == updatedStock.id);
      if (index != -1) {
        _stocks[index] = updatedStock;
        _stockStreamController.add(_stocks);
      }
    });
  }

  @override
  void dispose() {
    _stockStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF758694),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Stock'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Sales'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SalesPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Stock>>(
        stream: _stockStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stocks available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final stock = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockDetailPage(stock: stock),
                      ),
                    );
                    if (result == true) {
                      _removeStock(stock.id);
                    } else if (result == false) {
                      _fetchStocks();
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
                      title: Text(stock.name),
                      subtitle:
                          Text('Qty: ${stock.qty}, Issuer: ${stock.issuer}'),
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
          final newStock = await Navigator.push<Stock>(
            context,
            MaterialPageRoute(builder: (context) => AddStockPage()),
          );
          if (newStock != null) {
            _addStock(newStock);
          }
        },
        label: const Text('Tambah Stok', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF758694),
      ),
    );
  }
}
