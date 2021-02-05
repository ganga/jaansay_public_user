import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/profile/review_add_card.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isLoad = true;
  List<Review> reviews = [];
  List<OfficialDocument> officialDocuments = [];

  Review userReview;
  bool isCheck = false;
  Official official;

  getData() async {
    isLoad = true;
    setState(() {});
    reviews.clear();
    userReview = null;

    OfficialService officialService = OfficialService();
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments, official.officialsId.toString());
    userReview = await officialService
        .getOfficialRatings(official.officialsId.toString(), reviews);
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isCheck) {
      isCheck = true;
      official = ModalRoute.of(context).settings.arguments;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? Loading()
          : reviews.length == 0 && official.isFollow != 1
              ? CustomErrorWidget(
                  title: "No reviews",
                  iconData: Icons.not_interested,
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return index == 0
                        ? userReview == null
                            ? official.isFollow != 1
                                ? SizedBox.shrink()
                                : ReviewAddCard(
                                    official.officialsId.toString(), getData)
                            : ReviewCard(userReview)
                        : ReviewCard(reviews[index - 1]);
                  },
                  itemCount: reviews.length + 1,
                ),
    );
  }
}
