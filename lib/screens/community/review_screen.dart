import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/profile/review_add_card.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? ReviewAddCard() : ReviewCard();
        },
        itemCount: 6,
      ),
    );
  }
}
