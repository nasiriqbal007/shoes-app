import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;

  UserModel({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

 
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] as String,
      email: data['email'] as String,
    );
  }
}
