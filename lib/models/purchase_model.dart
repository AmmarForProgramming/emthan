class Purchase {
  int? id;
  int productId;
  int quantity;
  String productName;
  double unit_price;
  double totalCost;
  String date;

  Purchase({this.id,
   required this.productId,
    required this.quantity,
    required this.productName,
    required this.unit_price, 
    required this.totalCost,
     required this.date});

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      productName: map['productName'],
      unit_price: map['unit_price'],
      totalCost: map['total_cost'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'productName':productName,
      'unit_price':unit_price,
      'total_cost': totalCost,
      'date': date,
    };
  }
}