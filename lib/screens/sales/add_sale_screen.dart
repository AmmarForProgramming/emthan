import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/sale_model.dart';
import '../../providers/sales_provider.dart';
import '../../providers/purchases_provider.dart';
import '../../providers/product_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/notification_provider.dart';
import '../../constants/notification_service.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
class AddSalePage extends StatefulWidget {
  @override
  _AddSalePageState createState() => _AddSalePageState();
}
class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  Product? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  double _profitMargin = 0.4;
  double _purchasePrice = 0.0;

  void _calculateTotal() {
    if (_selectedProduct == null || _quantityController.text.isEmpty) return;

    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    final double   latssprice = purchaseProvider.getLatestPurchasePrice(_selectedProduct!.id.toString());
    setState(() {
    _purchasePrice=latssprice;
      double sellingPrice = _purchasePrice + (_purchasePrice * _profitMargin);
      _unitPriceController.text = sellingPrice.toStringAsFixed(2);
      
      int quantity = int.tryParse(_quantityController.text) ?? 0;
      double total = sellingPrice * quantity;
      _totalPriceController.text = total.toStringAsFixed(2);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final saleProvider = Provider.of<SaleProvider>(context);
    //final purchaseProvider = Provider.of<PurchaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مبيع', style:GoogleFonts.tajawal(),selectionColor:Colors.white,),
        backgroundColor: Colors.orange[800],
        iconTheme: IconThemeData(color: Colors.white)
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
                      value: product.id,
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
              TextFormField(style: GoogleFonts.tajawal(),
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'الكمية المباعة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.format_list_numbered, color: Colors.orange),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotal(),
                validator: (value) => value!.isEmpty ? 'أدخل الكمية' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                style: GoogleFonts.tajawal(),
                controller: _unitPriceController,
                decoration: InputDecoration(
                  labelText: 'سعر البيع (ريال)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.orange),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => _calculateTotal(),
                validator: (value) => value!.isEmpty ? 'أدخل السعر' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                style: GoogleFonts.tajawal(),
                controller: _totalPriceController,
                decoration: InputDecoration(
                  labelText: 'الإيراد (ريال)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.calculate, color: Colors.orange),
                ),
                readOnly: true,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.save, size: 24),
                label: Text('حفظ المبيع', style: GoogleFonts.tajawal()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedProduct != null) {
                    try {
                      final sale = Sale(
                        productId: _selectedProduct!.id!,
                        prodctName: _selectedProduct!.name,
                        quantity: int.parse(_quantityController.text),
                        unit_price: double.parse(_unitPriceController.text),
                        totalPrice: double.parse(_totalPriceController.text),
                        date: DateTime.now().toString(),
                      );
                      await saleProvider.addSale(sale);
                      Provider.of<NotificationsProvider>(context,listen: false).addNotification("عملية بيع جديدة","تم بيع ${sale.quantity}من المنتج رقم ${sale.prodctName}");
                      await NotificationService.showNotification(
                        title: "تمت العملية", 
                        body: "تمت إضافة البيع بنجاح");
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
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