import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_store/Model/cart_model.dart';
import 'package:nike_store/Model/fav_model.dart';
import 'package:nike_store/Model/user_model.dart';

class UserDatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference get userCollection => firestore.collection("User");

  Future<void> storeUser(UserModel user, String userId) async {
    try {
      await userCollection.doc(userId).set(user.toJson());
    } catch (e) {
      return;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection("User").doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> addItemToCart(String userId, CartItem cartItem) async {
    try {
      DocumentReference cartRef = firestore
          .collection("User")
          .doc(userId)
          .collection("Cart")
          .doc(cartItem.shoeId);

      DocumentSnapshot snapshot = await cartRef.get();
      if (snapshot.exists) {
        int currentQuantity =
            (snapshot.data() as Map<String, dynamic>)["quantity"] ?? 0;
        await cartRef.update({"quantity": currentQuantity + 1});
      } else {
        await cartRef.set(cartItem.toJson());
      }
    } catch (e) {
      return;
    }
  }

  Future<List<CartItem>> getCartItems(
    String userId,
  ) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("User")
          .doc(userId)
          .collection("Cart")
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartItem.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateCartItemQuantity(String userId, CartItem cartItem) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Cart')
          .doc(cartItem.shoeId)
          .update({'quantity': cartItem.quantity});
    } catch (e) {
      return;
    }
  }

  Future<void> removeFromCart(String userId, String cartItemId) async {
    try {
      await firestore
          .collection("User")
          .doc(userId)
          .collection("Cart")
          .doc(cartItemId)
          .delete();
    } catch (e) {
      return;
    }
  }

  Future<void> addItemToFavorite(
      String userId, FavoriteItem favoriteItem) async {
    try {
      DocumentReference favoriteRef = firestore
          .collection("User")
          .doc(userId)
          .collection("Favorite")
          .doc(favoriteItem.shoeId);
      DocumentSnapshot snapshot = await favoriteRef.get();
      if (snapshot.exists) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set(favoriteItem.toJson());
      }
    } catch (e) {
      null;
    }
  }

  Stream<List<FavoriteItem>> getFavoriteItemsStream(String userId) {
    return firestore
        .collection("User")
        .doc(userId)
        .collection("Favorite")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return FavoriteItem.fromJson(data);
      }).toList();
    });
  }

  Future<void> removeFromFavorite(String userId, String shoeId) async {
    try {
      await firestore
          .collection("User")
          .doc(userId)
          .collection("Favorite")
          .doc(shoeId)
          .delete();
    } catch (e) {
      return;
    }
  }
}
