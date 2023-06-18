import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaansay_public_user/models/constituency.dart';
import 'package:jaansay_public_user/models/poll.dart';
import 'package:jaansay_public_user/service/questionnaire_service.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card_section.dart';

class PollSection extends StatefulWidget {
  @override
  State<PollSection> createState() => _PollSectionState();
}

class _PollSectionState extends State<PollSection> {
  List<Constituency> constituencies = [new Constituency("Test")];
  List<Poll> polls = [new Poll()];

  QuestionnaireService _questionnaireService = QuestionnaireService();
  String dropdownValue;

  bool loading = true;

  Future<void> getAllConstituencies() async {
    await getAllPollData();
    setState(() {
      loading = false;
    });
  }

  Future<void> getAllPollData() async {
    constituencies = await _questionnaireService.getConstituencies();
    polls = await _questionnaireService.getPolls();
  }

  @override
  initState() {
    super.initState();
    getAllConstituencies();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return CircularProgressIndicator();
    return Column(children: [
      Column(children: [
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value;
            });
          },
          items: buildList(),
        )
      ]),
      PollCardSection(polls: polls, callback: () async{
        setState(() {
          loading = true;
        });
        await getAllPollData();
        setState(() {
          loading = false;
        });
      }),
    ]);
  }

  List<DropdownMenuItem<String>> buildList() => constituencies
      .map((e) =>
          new DropdownMenuItem<String>(value: e.name, child: Text(e.name)))
      .toList();
}
