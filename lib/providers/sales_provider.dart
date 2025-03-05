import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../models/sale_model.dart';
import '../database/db_helper.dart';
//import '../models/purchase_model.dart';
//import '../providers/notification_provider.dart';
//import '../providers/product_provider.dart';
class SaleProvider extends ChangeNotifier {
  List<Sale> _sales = [];
  //List<Purchase>_purchases=[];
  bool _isLoading = false;

  List<Sale> get sales => _sales;
  bool get isLoading => _isLoading;

SaleProvider(){
  fetchSales();
}


  Future<void> fetchSales() async {
    _isLoading = true;
    notifyListeners();
try{
    _sales = await DatabaseHelper.instance.getSales();
}catch(e){
      debugPrint("no activ");
}finally{
    _isLoading = false;
    notifyListeners();
}
  }

  Future<void> addSale(Sale sale) async {
try{
  final currentquna=await _getproductqu(sale.productId);
  if(currentquna<sale.quantity){
    throw Exception('noquntry');
  }
    await DatabaseHelper.instance.addSale(sale);
    await DatabaseHelper.instance.updateProductqun(sale.productId, -sale.quantity);
   //Provider.of<NotificationsProvider>(context,listen: false)
    await fetchSales();
    
  }catch (e){
   print("حدث خطأ$e"); 
  }


}
Future<int>_getproductqu(int product_id)async{
  final db=await DatabaseHelper.instance.database;
  final rusult=await db.query(
    'products',
    where: 'id=?',
    whereArgs: [product_id],
  );
  return rusult.first['quantity'] as int;
}


}