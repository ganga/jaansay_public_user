import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class ReviewAddCard extends StatefulWidget {
  final String officialId;
  final Function getReviews;

  ReviewAddCard(this.officialId, this.getReviews);

  @override
  _ReviewAddCardState createState() => _ReviewAddCardState();
}

class _ReviewAddCardState extends State<ReviewAddCard> {
  TextEditingController controller = TextEditingController();
  GetStorage box = GetStorage();
  String rating = "1";
  bool isLoad = false;

  addReview() async {
    isLoad = true;
    setState(() {});
    UserService userService = UserService();
    print(controller.text);
    await userService.addReview(widget.officialId, rating, controller.text);
    widget.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      child: isLoad
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _mediaQuery.width * 0.06,
                  vertical: _mediaQuery.height * 0.03),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: _mediaQuery.width * 0.15,
                        width: _mediaQuery.width * 0.15,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: CustomNetWorkImage(box.read("photo")),
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
                              "${box.read("user_name")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RatingBar(
                              itemSize: 30,
                              initialRating: 1,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (val) {
                                rating = val.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 2),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                          hintText: tr(
                              "Share details of your experience at this place"),
                          hintStyle: TextStyle(fontSize: 14)),
                      minLines: 5,
                      maxLines: 5,
                      style: TextStyle(fontSize: 14),
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        addReview();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
