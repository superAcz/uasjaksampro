class Shoe {
  final int? id;
  final String brand;
  final String size;
  final String purchaseDate;
  final String buyerName;

  Shoe({this.id, required this.brand, required this.size, required this.purchaseDate, required this.buyerName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'size': size,
      'purchaseDate': purchaseDate,
      'buyerName': buyerName,
    };
  }

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'],
      brand: map['brand'],
      size: map['size'],
      purchaseDate: map['purchaseDate'],
      buyerName: map['buyerName'],
    );
  }
}
