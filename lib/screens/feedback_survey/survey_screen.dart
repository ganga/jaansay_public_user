// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/screens/misc/done_screen.dart';
import 'package:jaansay_public_user/service/feedback_survey_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_button.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class SurveyScreen extends StatefulWidget {
  final int surveyId;

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
  int surveyId;
  int curIndex = 0;
  List<SurveyAnswer> surveyAnswers = [];
  FeedbackSurveyService surveyService = FeedbackSurveyService();
  bool isAnswered = false;

  getSurvey() async {
    await surveyService.getSurvey(surveys, surveyId.toString());
    surveys.map((e) {
      if (e.answerId != null) {
        surveyAnswers.add(
          SurveyAnswer(answerId: e.answerId, questionId: e.sqId),
        );
        isAnswered = true;
      }
    }).toList();
    isLoad = false;
    setState(() {});
  }

  nextPage() async {
    if (curIndex == surveys.length - 1) {
      if (isAnswered) {
        Get.close(1);
      } else {
        if (surveyAnswers.length != surveys.length) {
          List<int> tempSurvey = [];
          surveyAnswers.map((sa) {
            tempSurvey.add(sa.questionId);
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
          Get.off(
              DoneScreen(
                onTap: () => Get.close(1),
                title: "Survey Submitted",
                subTitle:
                    "Thank you for taking your time to answer this survey. You will start getting personalised offers and discounts when you answer surveys",
              ),
              transition: Transition.rightToLeft);
        }
      }
    } else {
      _controller.animateToPage(curIndex + 1,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  addAnswer(SurveyAnswer surveyAnswer) {
    int flag;

    surveyAnswers.map((e) {
      if (e.questionId == surveyAnswer.questionId) {
        flag = surveyAnswers.indexOf(e);
      }
    }).toList();

    if (flag == null) {
      surveyAnswers.add(
        SurveyAnswer(
            answerId: surveyAnswer.answerId,
            questionId: surveyAnswer.questionId),
      );
    } else {
      surveyAnswers.removeAt(flag);
      surveyAnswers.insert(
        flag,
        SurveyAnswer(
            answerId: surveyAnswer.answerId,
            questionId: surveyAnswer.questionId),
      );
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
                        return Container(
                          height: 5,
                          width: Get.width * 0.7 / surveys.length,
                          color: curIndex.round() == surveys.indexOf(e)
                              ? Theme.of(context).primaryColor
                              : Colors.black.withOpacity(0.2),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: (val) {
                        curIndex = val;
                        setState(() {});
                      },
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      children: surveys.map((e) {
                        return _SurveyQASection(e, surveys.indexOf(e) + 1,
                            isAnswered ? (_) {} : addAnswer, surveyAnswers);
                      }).toList(),
                    ),
                  ),
                  BottomButton(
                    onTap: () {
                      nextPage();
                    },
                    text: curIndex != surveys.length - 1
                        ? tr("Continue")
                        : isAnswered
                            ? "Close"
                            : "Finish",
                    backColor: curIndex == surveys.length - 1
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    textColor: curIndex != surveys.length - 1
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ],
              ),
            ),
    );
  }
}

class _SurveyQASection extends StatelessWidget {
  final Survey survey;
  final int index;
  final Function addAnswer;
  final List<SurveyAnswer> surveyAnswers;

  _SurveyQASection(this.survey, this.index, this.addAnswer, this.surveyAnswers);

  @override
  Widget build(BuildContext context) {
    int value;

    surveyAnswers.map((e) {
      if (e.questionId == survey.sqId) {
        final temp = e.answerId;
        survey.soId.map((e) {
          if (e == temp) {
            value = survey.soId.indexOf(e);
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
                    "Question $index",
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
                          addAnswer(SurveyAnswer(
                              questionId: survey.sqId, answerId: e));
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
