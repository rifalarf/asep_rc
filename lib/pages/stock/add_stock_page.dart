import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/stock.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  _AddStockPageState createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _attrController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();

  Future<void> _addStock() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://api.kartel.dev/stocks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'qty': int.parse(_qtyController.text),
          'attr': _attrController.text,
          'weight': double.parse(_weightController.text),
          'issuer': _issuerController.text,
        }),
      );

      if (response.statusCode == 201) {
        final newStock = Stock.fromJson(jsonDecode(response.body));
        print('$newStock telah ditambahkan'); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ditambahkan')),
        );
        Navigator.pop(
            context, newStock); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add stock')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Stok',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694), 
        iconTheme: const IconThemeData(
            color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan barang';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _qtyController,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan jumlah';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukan nomor';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _attrController,
                  decoration: const InputDecoration(labelText: 'Satuan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan satuan';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Berat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan berat';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukan Masukan ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _issuerController,
                  decoration: const InputDecoration(labelText: 'Vendor'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan vendor';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addStock,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambahkan',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF758694), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
