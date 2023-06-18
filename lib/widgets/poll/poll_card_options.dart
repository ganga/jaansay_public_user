import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card_option.dart';

class PollCardOptions extends StatefulWidget {
  const PollCardOptions({this.options, this.groupValue, this.disabled, this.callback});
  final callback;
  final String groupValue;
  final bool disabled;
  final List<PollQuestionOption> options;

  @override
  State<PollCardOptions> createState() => _PollCardOptions();
}

class _PollCardOptions extends State<PollCardOptions> {
  String _selectedOption;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
        child: Column(
            children: buildList()
        )
    );
  }

  List<RadioListTile> buildList() {
    String _groupValue = widget.groupValue ?? "guid";
    return widget.options.map((option) {
      return RadioListTile<String>(
        title: Text(option.description),
        groupValue: _groupValue,
        value: option.guid,
        onChanged: widget.disabled ? null : (value) {
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
