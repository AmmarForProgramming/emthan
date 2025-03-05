import 'package:flutter/material.dart';
import 'package:star_mobile/models/product_model.dart';
import '../models/purchase_model.dart';
import '../database/db_helper.dart';
//import './notification_provider.dart';
//import '../providers/product_provider.dart';
//import '../screens/notifications_screen.dart';
//import '../providers/notification_provider.dart';
//import '../providers/product_provider.dart';
class PurchaseProvider extends ChangeNotifier {
  List<Purchase> _purchases = [];


  double getLatestPurchasePrice(String productId) {
    final purchases = _purchases.where((p) => p.productId == productId).toList();
    if (purchases.isEmpty) return 0.0;
    purchases.sort((a, b) => b.date.compareTo(a.date));
    return purchases.first.totalCost;
  }
  
  bool _isLoading = false;

  List<Purchase> get purchases => _purchases;
  bool get isLoading => _isLoading;

PurchaseProvider(){
  fetchPurchases();
}
  Future<void> fetchPurchases() async {
    _isLoading = true;
    notifyListeners();
try{
    _purchases = await DatabaseHelper.instance.getPurchases();
}catch (e){  debugPrint("no activ");

   }finally{
    _isLoading = false;
    notifyListeners();
}
  }

  Future<void> addPurchase(Purchase purchase) async {
try{
    await DatabaseHelper.instance.addPurchase(purchase);
    await DatabaseHelper.instance.updateProductqun(purchase.productId, purchase.quantity,);
    await fetchPurchases();
    //await checkLowStock();
    notifyListeners();
  }catch (e){
     print('nopro$e');
  }
  }

}