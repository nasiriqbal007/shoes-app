import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_store/Model/shoes_model.dart';

class ShoeDatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get categoryCollection =>
      firestore.collection("Categories");

  Future<List<ShoeCategory>> fetchAllCategoriesWithShoes() async {
    try {
      QuerySnapshot snapshot = await categoryCollection.get();
      List<ShoeCategory> categories = [];

      for (var doc in snapshot.docs) {
        String categoryId = doc.id;
        String categoryName = doc['category'];

        List<Shoe> shoes = await fetchShoesForCategory(categoryId);

        categories.add(ShoeCategory(
          id: categoryId,
          shoeCategories: categoryName,
          shoes: shoes,
        ));
      }
      return categories;
    } catch (e) {
      return [];
    }
  }

  Future<List<Shoe>> fetchShoesForCategory(String categoryId) async {
    try {
      QuerySnapshot shoeSnapshot =
          await categoryCollection.doc(categoryId).collection('Shoes').get();

      return shoeSnapshot.docs.map((shoeDoc) {
        String shoeId = shoeDoc.id;
        Map<String, dynamic> shoeData = shoeDoc.data() as Map<String, dynamic>;
        return Shoe.fromJson({
          'id': shoeId,
          ...shoeData,
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
