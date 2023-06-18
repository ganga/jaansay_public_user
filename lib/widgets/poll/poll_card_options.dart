import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';

class PollCardOptions extends StatefulWidget {
  const PollCardOptions({this.options, this.callback});
  final callback;
  final List<PollQuestionOption> options;

  @override
  State<PollCardOptions> createState() => _PollCardOptions();
}

class _PollCardOptions extends State<PollCardOptions> {
  int _selectedOption;
  int _groupValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(children: buildList());
  }

  List<RadioListTile<int>> buildList() {
    return widget.options.map((option) {
      return RadioListTile(
        title: Text(option.description),
        groupValue: _groupValue,
        value: option.id,
        onChanged: (value) {
          setState(() {
            _selectedOption = value;
            _groupValue = value;
            widget.callback(value);
          });
        },
      );
    }).toList();
  }
}
