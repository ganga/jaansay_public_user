import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';

class PollCardOption extends StatefulWidget {
  const PollCardOption(
      {this.option, this.isDisabled, this.groupValue, this.callback});

  final callback;
  final PollQuestionOption option;
  final String groupValue;
  final bool isDisabled;

  @override
  State<PollCardOption> createState() => _PollCardOption();
}

class _PollCardOption extends State<PollCardOption> {
  @override
  Widget build(BuildContext context) {
    String _groupValue = widget.groupValue;
    bool isDisabled = widget.isDisabled;
    PollQuestionOption option = widget.option;
    return RadioListTile(
      title: Text(option.description),
      groupValue: _groupValue,
      value: option.guid,
      onChanged: isDisabled
          ? null
          : (value) {
              setState(() {
                _groupValue = value;
                widget.callback(value);
              });
            },
    );
  }
}
