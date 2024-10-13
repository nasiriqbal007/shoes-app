class CartItem {
  final String userId;
  final String shoeId;
  final String shoeName;
  final double shoePrice;
  final String shoeImagePath;
  final String category;
  final String shoeDescription;

  int quantity;

  CartItem({
    required this.userId,
    required this.shoeId,
    required this.shoeName,
    required this.shoePrice,
    required this.shoeImagePath,
    required this.shoeDescription,
    required this.category,
    this.quantity = 1,
  });

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 1) {}
    quantity--;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shoeId': shoeId,
      'shoeName': shoeName,
      'shoePrice': shoePrice,
      'shoeImagePath': shoeImagePath,
      'quantity': quantity,
      'category': category,
      'shoeDescription': shoeDescription,
    };
  }

  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      userId: json['userId'],
      shoeId: json['shoeId'],
      shoeName: json['shoeName'],
      shoePrice: json['shoePrice'],
      shoeImagePath: json['shoeImagePath'],
      quantity: json['quantity'],
      category: json['category'],
      shoeDescription: json['shoeDescription'],
    );
  }
}
