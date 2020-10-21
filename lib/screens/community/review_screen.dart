import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/profile/review_add_card.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isLoad = true;
  List<Review> reviews = [];
  Review userReview;
  bool isCheck = false;
  String officialId = "";

  getData() async {
    isLoad = true;
    setState(() {});
    reviews.clear();
    userReview = null;
    OfficialService officialService = OfficialService();
    final List response = await officialService.getOfficialRatings(officialId);
    userReview = response[0];
    reviews = response[1];
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isCheck) {
      isCheck = true;
      officialId = ModalRoute.of(context).settings.arguments;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? Loading()
          : ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? userReview == null
                        ? ReviewAddCard(officialId, getData)
                        : ReviewCard(userReview)
                    : ReviewCard(reviews[index - 1]);
              },
              itemCount: reviews.length + 1,
            ),
    );
  }
}
