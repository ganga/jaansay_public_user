import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/catalog.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  OrderDetailScreen(this.order);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Order Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
