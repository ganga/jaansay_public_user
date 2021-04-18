import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/feedback_survey/feedback_list_screen.dart';
import 'package:jaansay_public_user/screens/feedback_survey/survey_list_screen.dart';
import 'package:jaansay_public_user/service/feedback_survey_service.dart';
import 'package:jaansay_public_user/widgets/dashboard/dash_list.dart';

class SurveyFeedbackSection extends StatefulWidget {
  @override
  _SurveyFeedbackSectionState createState() => _SurveyFeedbackSectionState();
}

class _SurveyFeedbackSectionState extends State<SurveyFeedbackSection> {
  bool isLoad = true;
  List<Official> officials = [];
  FeedbackSurveyService surveyService = FeedbackSurveyService();

  getDashOfficials() async {
    await surveyService.getDashFeedbackSurvey(officials);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashOfficials();
  }

  @override
  Widget build(BuildContext context) {
    return DashList(
      officials: officials,
      title: "Feedback / Surveys",
      isLoad: isLoad,
      onTap: (index) {
        if (officials[index].kmId == 1) {
          Get.to(() => FeedbackListScreen(officials[index]),
              transition: Transition.rightToLeft);
        } else {
          Get.to(() => SurveyListScreen(officials[index]),
              transition: Transition.rightToLeft);
        }
      },
    );
  }
}
