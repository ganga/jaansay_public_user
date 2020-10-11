import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/profile/deal_card.dart';

class DealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return DealCard();
        },
        itemCount: 8,
      ),
    );
  }
}
