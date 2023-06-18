import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaansay_public_user/models/poll_question.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card_options.dart';

class PollCard extends StatefulWidget {
  const PollCard({ this.question });
  final PollQuestion question;
  @override
  State<PollCard> createState() => _PollCardState();

}

class _PollCardState extends State<PollCard> {
  int _selectedOption;

  int get selectedOption => _selectedOption;

  set selectedOption(int value) {
    _selectedOption = value;
  }

  @override
  void initState() {
    setState(() {
      _selectedOption = widget.question.options.first.id;
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
            PollCardOptions(options: question.options),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Vote'),
                  onPressed: () {
                    log('$selectedOption');
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            ],
      ),
    );
  }

}