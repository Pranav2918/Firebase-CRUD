import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseServices {
  static Future<void> addUser(String name, String profession) async {
    FirebaseFirestore.instance
        .collection("users")
        .add({"name": name, "profession": profession});
  }

  static Future<void> deleteUser(
      AsyncSnapshot<QuerySnapshot> snapshot, int index) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(snapshot.data!.docs[index].id)
        .delete();
  }
}
