import 'package:asep_rc/model/sales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'add_sales_page.dart';
import 'sales_detail_page.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late StreamController<List<Sales>> _salesStreamController;
  List<Sales> _sales = [];

  @override
  void initState() {
    super.initState();
    _salesStreamController = StreamController<List<Sales>>.broadcast();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    final response = await http.get(Uri.parse('https://api.kartel.dev/sales'));

    if (response.statusCode == 200) {
      _sales = Sales.fromJsonList(response.body);
      _salesStreamController.add(_sales);
    } else {
      throw Exception('Failed to load sales');
    }
  }

  void _addSales(Sales newSales) {
    setState(() {
      _sales.add(newSales);
      _salesStreamController.add(_sales);
    });
  }

  void _removeSales(String id) {
    setState(() {
      _sales.removeWhere((sales) => sales.id == id);
      _salesStreamController.add(_sales);
    });
  }

  void _updateSales(Sales updatedSales) {
    setState(() {
      final index = _sales.indexWhere((sales) => sales.id == updatedSales.id);
      if (index != -1) {
        _sales[index] = updatedSales;
        _salesStreamController.add(_sales);
      }
    });
  }

  @override
  void dispose() {
    _salesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694),
      ),
      body: StreamBuilder<List<Sales>>(
        stream: _salesStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sales available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final sales = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesDetailPage(sales: sales),
                      ),
                    );
                    if (result == true) {
                      _removeSales(sales.id);
                    } else if (result == false) {
                      _fetchSales();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Text(sales.buyer),
                      subtitle: Text(
                        'Lihat detail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
          final newSales = await Navigator.push<Sales>(
            context,
            MaterialPageRoute(builder: (context) => AddSalesPage()),
          );
          if (newSales != null) {
            _addSales(newSales);
          }
        },
        label: const Text('Tambah Penjualan',
            style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF758694),
      ),
    );
  }
}
