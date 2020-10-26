
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtil{
  CollectionReference users = FirebaseFirestore.instance.collection('notification');

  Future<void> addNotification(String title,String body,String to) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'title': title.toUpperCase(), // John Doe
      'body': body, // Stokes and Sons
      'to': to,// 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}