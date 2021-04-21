import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/feedback_survey/survey_screen.dart';
import 'package:jaansay_public_user/service/feedback_survey_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyListScreen extends StatefulWidget {
  final Official official;

  SurveyListScreen(this.official);

  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  Official official;
  List<SurveyMaster> surveyMasters = [];
  FeedbackSurveyService feedbackSurveyService = FeedbackSurveyService();
  bool isLoad = true;

  getSurveyMasters() async {
    await feedbackSurveyService.getSurveyMasters(
        surveyMasters, official.officialsId.toString());
    isLoad = false;
    setState(() {});
  }

  surveyItem(SurveyMaster surveyMaster) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4),
            color: Theme.of(context).primaryColor,
            child: Text(
              DateFormat('d MMMM y').format(surveyMaster.updatedAt),
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Survey Title",
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).primaryColor),
                ).tr(),
                Text(
                  surveyMaster.surveyTitle,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Survey Description",
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).primaryColor),
                ).tr(),
                Text(
                  surveyMaster.surveyDescription,
                  style: TextStyle(fontSize: 16),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Get.off(() => SurveyScreen(surveyMaster.surveyId),
                          transition: Transition.rightToLeft);
                    },
                    child: Text(
                      surveyMaster.saId == null
                          ? "Answer Survey"
                          : "View Details",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    official = widget.official;
    getSurveyMasters();
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
              ProfileFullScreen(official.officialsId),
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
          ? CustomLoading(title: "Loading Surveys")
          : ListView.builder(
              itemCount: surveyMasters.length,
              itemBuilder: (context, index) {
                return surveyItem(surveyMasters[index]);
              },
            ),
    );
  }
}
