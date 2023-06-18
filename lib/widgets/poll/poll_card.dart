import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/poll_question.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card_options.dart';

class PollCard extends StatefulWidget {
  const PollCard({this.question, this.callback});

  final PollQuestion question;
  final callback;

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  String _selectedOption;

  String get selectedOption => _selectedOption;

  set selectedOption(String value) {
    _selectedOption = value;
  }

  @override
  void initState() {
    setState(() {
      _selectedOption = widget.question.options.first.guid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PollQuestion question = widget.question;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text(question.description),
          ),
          PollCardOptions(
            options: question.options,
            groupValue: question.selectedOptionGuid,
            disabled: question.isVoted,
            callback: (selectedOption) => setState(() {
              _selectedOption = selectedOption;
            })
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              voteFunctionality(),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget voteFunctionality() {
    PollQuestion question = widget.question;
    if (question.isVoted) {
      return Text("Already voted");
    } else {
      return TextButton(
        child: const Text('Vote'),
        onPressed: () {
          log('$selectedOption');
          widget.callback(widget.question.guid, selectedOption);
        },
      );
    }
  }
}
