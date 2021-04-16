import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: _mediaQuery.width * 0.15,
              width: _mediaQuery.width * 0.15,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: CustomNetWorkImage(review.photo),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${review.userName}",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RatingBar(
                    itemSize: 20,
                    initialRating: double.parse(review.rating.toString()),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        )),
                    onRatingUpdate: (rating) {},
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text("${review.ratingMessage ?? ''}"),
                  SizedBox(
                    height: _mediaQuery.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
