import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
//import '../../models/sale_model.dart';
import 'add_sale_screen.dart';
//import '../../providers/product_provider.dart';
class SalesPage extends StatefulWidget {
  const SalesPage({super.key});


  @override
  State<SalesPage> createState()=>_SalesPage();
}

class _SalesPage extends State<SalesPage> {
 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_){
   Provider.of<SaleProvider>(context,listen: false) .fetchSales();
 
  });
    }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المبيعات', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSalePage()),
            ),
          ),
        ],
      ),
      body: Consumer<SaleProvider>(
        builder: (context, saleProvider, _) {
          if (saleProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: saleProvider.sales.length,
            separatorBuilder: (context, index) => Divider(height: 20),
            itemBuilder: (context, index) {
              final sale = saleProvider.sales[index];
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
                  title: Text('الاسم: ${sale.prodctName}'),
                  subtitle:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الكمية${sale.quantity}'),
                    Text('التأريخ${sale.totalPrice}')
                  ],
                                       ),
                    
                  trailing: Text('السعر : ${sale.totalPrice}'),
    
                  leading: Icon(Icons.attach_money, color: Colors.orange),
                ),
              );
            },
          );
        },
      ),
    );
  }
}