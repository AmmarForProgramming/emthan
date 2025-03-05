class Sale {
  int? id;
  int productId;
  int quantity;
  String prodctName;
  double unit_price;
  double totalPrice;
  String date;

  Sale({this.id, 
  required this.productId,
   required this.quantity,
   required this.prodctName,
required this.unit_price,
    required this.totalPrice,
     required this.date});

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      prodctName: map['productName'],
      unit_price: map['unit_price'],
      totalPrice: map['total_price'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'productName':prodctName,
      'unit_price':unit_price,
      'total_price': totalPrice,
      'date': date,
    };
  }
}