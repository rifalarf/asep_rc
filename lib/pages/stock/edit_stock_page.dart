import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/stock.dart';

class EditStockPage extends StatefulWidget {
  final Stock stock;

  const EditStockPage({required this.stock, super.key});

  @override
  _EditStockPageState createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _attrController;
  late TextEditingController _weightController;
  late TextEditingController _issuerController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stock.name);
    _qtyController = TextEditingController(text: widget.stock.qty.toString());
    _attrController = TextEditingController(text: widget.stock.attr);
    _weightController =
        TextEditingController(text: widget.stock.weight.toString());
    _issuerController = TextEditingController(text: widget.stock.issuer);
  }

  Future<void> _updateStock() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('https://api.kartel.dev/stocks/${widget.stock.id}'),
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ber')),
        );
        Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Stok',
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
                onPressed: _updateStock,
                icon: const Icon(Icons.save, color: Colors.white),
                label:
                    const Text('Simpan', style: TextStyle(color: Colors.white)),
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
