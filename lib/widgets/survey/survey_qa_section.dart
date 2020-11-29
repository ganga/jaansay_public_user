import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/survey.dart';

class SurveyQASection extends StatefulWidget {
  final Survey survey;
  final int index;
  final Function addAnswer;
  final List surveyAnswers;

  SurveyQASection(this.survey, this.index, this.addAnswer, this.surveyAnswers);

  @override
  _SurveyQASectionState createState() => _SurveyQASectionState();
}

class _SurveyQASectionState extends State<SurveyQASection> {
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
