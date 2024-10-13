class Shoe {
  String id;
  String name;
  double price;
  String description;
  String imagePath;

  Shoe({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      name: json['shoeName'],
      price: (json['shoePrice'] as num).toDouble(),
      description: json['shoeDescription'],
      imagePath: json['shoeImage'],
    );
  }

  // Convert a Shoe instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shoeName': name,
      'shoePrice': price,
      'shoeDescription': description,
      'shoeImage': imagePath,
    };
  }
}

class ShoeCategory {
  String id;
  final String shoeCategories;
  final List<Shoe> shoes;

  ShoeCategory({
    required this.id,
    required this.shoeCategories,
    required this.shoes,
  });

  factory ShoeCategory.fromJson(Map<String, dynamic> json) {
    var shoeList = json['shoes'] as List;
    List<Shoe> shoes =
        shoeList.map((shoeJson) => Shoe.fromJson(shoeJson)).toList();

    return ShoeCategory(
      id: json['id'],
      shoeCategories: json['category'],
      shoes: shoes,
    );
  }

  // Convert a ShoeCategory instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': shoeCategories, // Ensure this matches Firestore field
      'shoes': shoes
          .map((shoe) => shoe.toJson())
          .toList(), // Serialize list of shoes
    };
  }
}
