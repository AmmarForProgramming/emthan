import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;
  AddEditProductPage({this.product});

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'إضافة منتج' : 'تعديل منتج',
          style:const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم المنتج',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.shopping_bag, color: Colors.deepPurple),
                ),
                validator: (value) => value!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.save, color: Colors.white),
                label: Text('حفظ', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProduct = Product(
                      id: widget.product?.id,
                      name: _nameController.text,
                      quantity: widget.product?.quantity ?? 0,
                    );
                    if (widget.product == null) {
                      Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
                    } else {
                      
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}