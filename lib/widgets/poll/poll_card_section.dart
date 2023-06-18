import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaansay_public_user/models/poll.dart';
import 'package:jaansay_public_user/models/poll_question.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card.dart';


class PollCardSection extends StatefulWidget {
  const PollCardSection({
   this.polls
});
  final List<Poll> polls;
  @override
  State<PollCardSection> createState() => _PollCardSectionState();
}

class _PollCardSectionState extends State<PollCardSection> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
    children: widget.polls.map((questiontionnaire) {
      PollQuestion question = questiontionnaire.questions.first;
      return  PollCard(question: question);
    }).toList()
    );
  }
}
