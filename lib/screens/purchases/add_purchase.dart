import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/purchases_provider.dart';
//import '../../database/db_helper.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
class AddPurchasePage extends StatefulWidget {
  @override
  _AddPurchasePageState createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  Product? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();

  void _calculateTotal() {
    if (_quantityController.text.isNotEmpty && _unitPriceController.text.isNotEmpty) {
      final total = double.parse(_quantityController.text) * double.parse(_unitPriceController.text);
      _totalCostController.text = total.toStringAsFixed(2);
    }
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final purchaseProvider = Provider.of<PurchaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة شراء', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        backgroundColor: Colors.teal[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
                    SearchableDropdown.single(
                items: productProvider.products
                    .map((product) => DropdownMenuItem(
                      value: product,
                          child: Text(product.name),
                          
                        ))
                    .toList(),
                hint: "اختر المنتج",
                searchHint: "بحث عن المنتج...",
                onChanged: (Product? newValue) {
                  setState(() {
                    _selectedProduct = newValue;
                  });
                },
                isExpanded: true,
                displayClearIcon: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'الكمية المشتراة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.format_list_numbered, color: Colors.teal),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotal(),
                validator: (value) => value!.isEmpty ? 'أدخل الكمية' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(
                  labelText: 'سعر الوحدة (ريال)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => _calculateTotal(),
                validator: (value) => value!.isEmpty ? 'أدخل السعر' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _totalCostController,
                decoration: InputDecoration(
                  labelText: 'الإجمالي (ريال)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.calculate, color: Colors.teal),
                ),
                readOnly: true,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.save, size: 24),
                label: Text('حفظ الشراء', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _selectedProduct != null) {
                    final purchase = Purchase(
                      productId: _selectedProduct!.id!,
                      quantity: int.parse(_quantityController.text),
                      productName: _selectedProduct!.name,
                      unit_price: double.parse(_unitPriceController.text),
                      totalCost: double.parse(_totalCostController.text),
                      date: DateTime.now().toString(),
                    );
                    purchaseProvider.addPurchase(purchase);
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