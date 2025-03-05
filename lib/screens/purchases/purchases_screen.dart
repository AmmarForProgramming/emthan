
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/purchases_provider.dart';
import 'add_purchase.dart';

class PurchasesPage extends StatefulWidget{
  const PurchasesPage({super.key});
  @override
  State<PurchasesPage> createState()=>_PurchasesPage();

}
class _PurchasesPage extends State<PurchasesPage> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_){
   Provider.of<PurchaseProvider>(context,listen: false) .fetchPurchases();
  });
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('المشتريات', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPurchasePage()),
            ),
          ),
        ],
      ),
      body: Consumer<PurchaseProvider>(
        builder: (context, purchaseProvider, _) {
          if (purchaseProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: purchaseProvider.purchases.length,
            separatorBuilder: (context, index) => Divider(height: 20),
            itemBuilder: (context, index) {
              final purchase = purchaseProvider.purchases[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text('الاسم: ${purchase.productName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('الكمية:${purchase.quantity}'),
                     Text('التاريخ: ${purchase.date.split(' ')[0]}'),
                    ],
                  ),
                  trailing:Text('السعر:${purchase.totalCost}'),
                  leading: Icon(Icons.shopping_cart, color: Colors.teal),
                ),
              );
            },
          );
        },
      ),
    );
  }
}