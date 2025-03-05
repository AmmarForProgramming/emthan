
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
//import 'package:star_mobile/models/purchase_model.dart';
import '../models/product_model.dart';
import '../database/db_helper.dart';
import '../providers/notification_provider.dart';
class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  
  //final int _lowStock=5;
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

ProductProvider(){
  fetchProducts();
}

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    
try{
    _products = await DatabaseHelper.instance.getProducts();
notifyListeners();
    //await checkLowStock();
}catch (e){
  debugPrint("no activ");
}
finally{
    _isLoading = false;
    notifyListeners();
}
}

  Future<void> addProduct(Product product) async {
    try{
    await DatabaseHelper.instance.addProduct(product);
    await fetchProducts();
    }catch(e){
      print("حدث خطأ اثناء اضافة المنتج$e");
    }
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    await fetchProducts();
  }

Future<void> updateStock(int productId, int newStock, BuildContext context) async {
  final db = await DatabaseHelper.instance.database;
  await db.update(
    'products',
    {'stock': newStock},
    where: 'id = ?',
    whereArgs: [productId],
  );
  // **تحقق من انخفاض المخزون**
  if (newStock <= 5) {
    Provider.of<NotificationsProvider>(context, listen: false)
        .addNotification("تنبيه انخفاض المخزون", "المنتج رقم $productId منخفض المخزون!");
  }
  fetchProducts();
}

}