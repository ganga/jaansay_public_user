import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/feedback_survey_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_button.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class SurveyScreen extends StatefulWidget {
  final String surveyId;

  SurveyScreen(this.surveyId);

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
  FeedbackSurveyService surveyService = FeedbackSurveyService();

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
        await surveyService.addSurvey(surveyAnswers, surveyId.toString());
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
    surveyId = widget.surveyId;
    getSurvey();
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoad
          ? CustomLoading(
              title: "Loading Survey",
            )
          : Container(
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
                              color:
                                  curIndex.value.round() == surveys.indexOf(e)
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
                        return _SurveyQASection(e, surveys.indexOf(e) + 1,
                            addAnswer, surveyAnswers);
                      }).toList(),
                    ),
                  ),
                  Obx(
                    () => BottomButton(
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

class _SurveyQASection extends StatefulWidget {
  final Survey survey;
  final int index;
  final Function addAnswer;
  final List surveyAnswers;

  _SurveyQASection(this.survey, this.index, this.addAnswer, this.surveyAnswers);

  @override
  __SurveyQASectionState createState() => __SurveyQASectionState();
}

class __SurveyQASectionState extends State<_SurveyQASection> {
  int value;

  @override
  Widget build(BuildContext context) {
    final survey = widget.survey;

    widget.surveyAnswers.map((e) {
      if (e['sq_id'] == survey.sqId.toString()) {
        final temp = int.parse(e['so_id']);
        widget.survey.soId.map((e) {
          if (int.parse(e.toString()) == temp) {
            value = widget.survey.soId.indexOf(e);
          }
        }).toList();
      }
    }).toList();

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(top: Get.height * 0.18, bottom: Get.height * 0.05),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question ${widget.index}",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    survey.sqQuestion,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Column(
              children: survey.soId.map((e) {
                return Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.06, vertical: 4),
                    child: Material(
                      color: survey.soId.indexOf(e) == value
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      child: RadioListTile(
                        onChanged: (val) {
                          widget.addAnswer(
                              survey.sqId.toString(), e.toString());
                          value = val;
                          setState(() {});
                        },
                        title: Text(survey.soOption[survey.soId.indexOf(e)]),
                        groupValue: value,
                        value: survey.soId.indexOf(e),
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
