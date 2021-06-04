// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/service/feedback_survey_service.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_head.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class FeedbackListScreen extends StatefulWidget {
  final Official official;

  FeedbackListScreen(this.official);

  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  List<FeedbackMaster> feedbackList = [];
  Official official;
  bool isLoad = true;
  FeedbackSurveyService feedbackSurveyService = FeedbackSurveyService();
  getAllFeedback() async {
    await feedbackSurveyService.getFeedbackByOfficialId(
        feedbackList, official.officialsId.toString());
    isLoad = false;
    setState(() {});
  }

  submitFeedback(int feedbackId, String answer) {
    feedbackList.map((e) {
      if (e.id == feedbackId) {
        e.answer = answer;
      }
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    official = widget.official;
    getAllFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: 50,
        title: InkWell(
          onTap: () {
            officialProfileProvider.clearData();

            Get.until((route) => route.isFirst);
            Get.to(
              ProfileFullScreen(
                official.officialsId,
              ),
            );
          },
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: CustomNetWorkImage(official.photo)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                official.officialsName,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              final url = "tel:${official.officialDisplayPhone}";
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.call,
                size: 26,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: isLoad
          ? CustomLoading()
          : ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                return _FeedbackItem(feedbackList[index], submitFeedback);
              },
            ),
    );
  }
}

class _FeedbackItem extends StatefulWidget {
  final FeedbackMaster feedback;
  final Function onSubmit;

  _FeedbackItem(this.feedback, this.onSubmit);

  @override
  __FeedbackItemState createState() => __FeedbackItemState();
}

class __FeedbackItemState extends State<_FeedbackItem> {
  FeedbackSurveyService feedbackSurveyService = FeedbackSurveyService();
  TextEditingController controller = TextEditingController();
  FeedbackMaster feedbackMaster;
  bool isLoad = false;

  submitFeedback() async {
    String answer = controller.text.trim();
    if (answer.length > 0) {
      isLoad = true;
      setState(() {});
      await feedbackSurveyService.addFeedback(
          feedbackMaster.id.toString(), answer);
      widget.onSubmit(feedbackMaster.id, answer);
    } else {
      Get.rawSnackbar(message: "Please enter your feedback");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedbackMaster = widget.feedback;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedbackMaster.message,
            ),
            const SizedBox(
              height: 4,
            ),
            if (feedbackMaster.mediaUrls.length > 0)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 8, top: 8),
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 16),
                  itemBuilder: (context, index) {
                    return ImageHolder(feedbackMaster.mediaUrls[index]);
                  },
                  itemCount: feedbackMaster.mediaUrls.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            Text(
              DateFormat("dd MMMM yyyy").format(feedbackMaster.createdAt),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 8,
            ),
            feedbackMaster.answer == null
                ? Column(
                    children: [
                      LongTextField(
                        hint: "Enter your feedback here",
                        controller: controller,
                        minLines: 3,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            submitFeedback();
                          },
                          child: Text("Submit"))
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Feedback:",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      Text(feedbackMaster.answer),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
