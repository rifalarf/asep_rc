import 'package:asep_rc/model/sales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSalesPage extends StatefulWidget {
  final Sales sales;

  const EditSalesPage({required this.sales, Key? key}) : super(key: key);

  @override
  _EditSalesPageState createState() => _EditSalesPageState();
}

class _EditSalesPageState extends State<EditSalesPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _buyerController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  late TextEditingController _statusController;
  late TextEditingController _issuerController;

  @override
  void initState() {
    super.initState();
    _buyerController = TextEditingController(text: widget.sales.buyer);
    _phoneController = TextEditingController(text: widget.sales.phone);
    _dateController = TextEditingController(text: widget.sales.date);
    _statusController = TextEditingController(text: widget.sales.status);
    _issuerController = TextEditingController(text: widget.sales.issuer);
  }

  Future<void> _updateSales() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('https://api.kartel.dev/sales/${widget.sales.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'buyer': _buyerController.text,
          'phone': _phoneController.text,
          'date': _dateController.text,
          'status': _statusController.text,
          'issuer': _issuerController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sales updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update sales')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  controller: _buyerController,
                  decoration: const InputDecoration(labelText: 'Pembeli'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a buyer';
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
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telepon'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
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
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Tanggal'),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
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
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a status';
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
                      return 'Please enter an issuer';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _updateSales,
                icon: const Icon(Icons.save, color: Colors.white),
                label:
                    const Text('Simpan', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF758694),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
