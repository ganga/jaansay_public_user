import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaansay_public_user/models/poll.dart';
import 'package:jaansay_public_user/models/poll_question.dart';
import 'package:jaansay_public_user/service/questionnaire_service.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card.dart';

class PollCardSection extends StatefulWidget {
  const PollCardSection({this.polls, this.callback});
  final List<Poll> polls;
  final callback;
  @override
  State<PollCardSection> createState() => _PollCardSectionState();
}

class _PollCardSectionState extends State<PollCardSection> {
  QuestionnaireService _questionnaireService = QuestionnaireService();
  vote(String questionnaireGuid, String questionGuid, String optionGuid) async {
    await _questionnaireService.vote(questionnaireGuid, questionGuid, optionGuid);
    await widget.callback();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.polls.map((questiontionnaire) {
      PollQuestion question = questiontionnaire.questions.first;
      return PollCard(question: question, callback: (questionGuid, optionGuid) => vote(questiontionnaire.guid, questionGuid, optionGuid));
    }).toList());
  }
}
