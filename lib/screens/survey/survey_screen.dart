import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/survey_service.dart';
import 'package:jaansay_public_user/widgets/survey/survey_bottom_button.dart';
import 'package:jaansay_public_user/widgets/survey/survey_qa_section.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<Survey> surveys = [];
  bool isLoad = true;
  String surveyId;
  bool isCheck = false;
  var curIndex = 0.obs;
  List surveyAnswers = [];
  String messageId;
  SurveyService surveyService = SurveyService();

  getSurvey() async {
    await surveyService.getSurvey(surveys, surveyId.toString());
    isLoad = false;
    setState(() {});
  }

  nextPage() async {
    if (curIndex.value == surveys.length - 1) {
      if (surveyAnswers.length != surveys.length) {
        List<String> tempSurvey = [];
        surveyAnswers.map((sa) {
          tempSurvey.add(sa['sq_id']);
        }).toList();
        surveys.map((s) {
          if (!tempSurvey.contains(s.sqId.toString())) {
            _controller.animateToPage(surveys.indexOf(s),
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }
        }).toList();
      } else {
        isLoad = true;
        setState(() {});
        await surveyService.addSurvey(
            surveyAnswers, surveyId.toString(), messageId);
        Get.offAll(HomeScreen());
        Get.rawSnackbar(message: tr('Survey response submitted. Thank you'));
      }
    } else {
      _controller.animateToPage(curIndex.value + 1,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  addAnswer(String qId, String oId) {
    int flag;

    surveyAnswers.map((e) {
      if (e['sq_id'] == qId) {
        flag = surveyAnswers.indexOf(e);
      }
    }).toList();

    if (flag == null) {
      surveyAnswers.add({
        "sq_id": qId,
        "so_id": oId,
      });
    } else {
      surveyAnswers.removeAt(flag);
      surveyAnswers.insert(flag, {
        "sq_id": qId,
        "so_id": oId,
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;

    if (!isCheck) {
      isCheck = !isCheck;
      messageId = response[0].toString();
      surveyId = response[1];
      getSurvey();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "${tr('Survey')}",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.06,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: surveys.map((e) {
                  return Obx(() => Container(
                        height: 5,
                        width: Get.width * 0.7 / surveys.length,
                        color: curIndex.value.round() == surveys.indexOf(e)
                            ? Theme.of(context).primaryColor
                            : Colors.black.withOpacity(0.2),
                      ));
                }).toList(),
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (val) {
                  curIndex(val);
                },
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: surveys.map((e) {
                  return SurveyQASection(
                      e, surveys.indexOf(e) + 1, addAnswer, surveyAnswers);
                }).toList(),
              ),
            ),
            Obx(
              () => SurveyBottomButton(
                onTap: () {
                  nextPage();
                },
                text: curIndex.value != surveys.length - 1
                    ? tr("Continue")
                    : "Finish",
                backColor: curIndex.value == surveys.length - 1
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                textColor: curIndex.value != surveys.length - 1
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
