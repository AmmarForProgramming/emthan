//import 'package:star_mobile/models/purchase_model.dart';

class Product {
  int? id;
  String name;
  int quantity;



  Product({this.id, 
  required this.name,
    required this.quantity
    
    });
     
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }
}