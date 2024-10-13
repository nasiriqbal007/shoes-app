class FavoriteItem {
  final String userId;
  final String shoeId;
  final String shoeName;
  final double shoePrice;
  final String shoeImagePath;
  final String shoeDescription;
  final String category;

  FavoriteItem(
      {required this.userId,
      required this.shoeId,
      required this.shoeName,
      required this.shoePrice,
      required this.shoeImagePath,
      required this.shoeDescription,
      required this.category});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shoeId': shoeId,
      'shoeName': shoeName,
      'shoePrice': shoePrice,
      'shoeImagePath': shoeImagePath,
      'shoeDescription': shoeDescription,
      'category': category
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      userId: json['userId'],
      shoeId: json['shoeId'],
      shoeName: json['shoeName'],
      shoePrice: json['shoePrice'],
      shoeImagePath: json['shoeImagePath'],
      shoeDescription: json['shoeDescription'],
      category: json['category'],
    );
  }
}
