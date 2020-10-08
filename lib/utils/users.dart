import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/user.dart';

class Users {
  List<User> _users = [];

  String getFacultyName(String id) {
    String name = "";
    _users.map((e) {
      if (e.id == id) {
        name = e.name;
      }
    }).toList();
    return name;
  }
}
