import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaansay_public_user/models/constituency.dart';
import 'package:jaansay_public_user/service/questionnaire_service.dart';

class PollSection extends StatefulWidget {
  @override
  State<PollSection> createState() => _PollSectionState();
}

class _PollSectionState extends State<PollSection> {
  List<Constituency> constituencies = [ new Constituency("Test")];
  QuestionnaireService _questionnaireService = QuestionnaireService();
  String dropdownValue;

  bool loading = true;
  getAllConstituencies() async {
    constituencies = await _questionnaireService.getConstituencies();
    setState((){
      loading = false;
    });
  }

  @override
  initState()  {
    super.initState();
    getAllConstituencies();
  }

  @override
  Widget build(BuildContext context) {
    if(loading) return CircularProgressIndicator();
    return Column(
      children: [
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
    ),
        Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Vote'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    ]
    );
  }

  List<DropdownMenuItem<String>> buildList() => constituencies.map((e) => new DropdownMenuItem<String>(value: e.name, child: Text(e.name))).toList();
}
