import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'shoe.dart';

class ShoeFormPage extends StatefulWidget {
  final Shoe? shoe;

  ShoeFormPage({this.shoe});

  @override
  _ShoeFormPageState createState() => _ShoeFormPageState();
}

class _ShoeFormPageState extends State<ShoeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _brand;
  late String _size;
  late String _buyerName;
  DateTime? _purchaseDate;

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      _brand = widget.shoe!.brand;
      _size = widget.shoe!.size;
      _purchaseDate = DateTime.parse(widget.shoe!.purchaseDate);
      _buyerName = widget.shoe!.buyerName;
    } else {
      _brand = '';
      _size = '';
      _purchaseDate = DateTime.now();
      _buyerName = '';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final shoe = Shoe(
        id: widget.shoe?.id,
        brand: _brand,
        size: _size,
        purchaseDate: _purchaseDate!.toIso8601String(),
        buyerName: _buyerName,
      );

      if (widget.shoe == null) {
        await DBHelper().insertShoe(shoe.toMap());
      } else {
        await DBHelper().updateShoe(shoe.toMap());
      }

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _purchaseDate)
      setState(() {
        _purchaseDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoe == null ? 'Add Shoe' : 'Edit Shoe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _brand,
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (value) => value!.isEmpty ? 'Enter brand' : null,
                onSaved: (value) => _brand = value!,
              ),
              TextFormField(
                initialValue: _size,
                decoration: InputDecoration(labelText: 'Size'),
                validator: (value) => value!.isEmpty ? 'Enter size' : null,
                onSaved: (value) => _size = value!,
              ),
              TextFormField(
                initialValue: _buyerName,
                decoration: InputDecoration(labelText: 'Buyer Name'),
                validator: (value) => value!.isEmpty ? 'Enter buyer name' : null,
                onSaved: (value) => _buyerName = value!,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _purchaseDate == null
                          ? 'No date chosen!'
                          : 'Picked Date: ${_purchaseDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.shoe == null ? 'Add Shoe' : 'Update Shoe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
