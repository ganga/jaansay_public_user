import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/constituency.dart';
import 'package:jaansay_public_user/models/poll.dart';
import 'package:jaansay_public_user/screens/misc/common_util.dart';
import 'package:jaansay_public_user/service/questionnaire_service.dart';
import 'package:jaansay_public_user/widgets/poll/poll_card_section.dart';

class PollSection extends StatefulWidget {
  @override
  State<PollSection> createState() => _PollSectionState();
}

class _PollSectionState extends State<PollSection> {
  List<Constituency> constituencies = [];
  List<Poll> polls = [];
  GetStorage box = GetStorage();

  QuestionnaireService _questionnaireService = QuestionnaireService();
  String dropdownValue;

  bool loading = true;

  Future<void> getAllConstituencies() async {
    polls = await getAllPollData();
    setState(()  {
      loading = false;
    });
  }

  Future<List<Poll>> getAllPollData() async {
    constituencies = await _questionnaireService.getConstituencies();
    String constituencyKey = box.read("selectedConstituency") ?? constituencies.first.constituencyKey;
    box.write("selectedConstituency", constituencyKey);
    dropdownValue = constituencyKey;
    log(constituencyKey);
    return await _questionnaireService.getPolls(constituencyKey);
  }

  @override
  initState() {
    super.initState();
    getAllConstituencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildPollCardSection(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
         return CommonUtil.widgetBuilderWithDropDown(
           dropdownValue: dropdownValue,
           context: context,
           snapshot: snapshot,
             onDropdownValueChange: onDropdownValueChange,
           buildList: buildList
         );
        }
        ,
    );
  }

  Widget builder(BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if(!snapshot.hasData) { // not loaded
          return  CircularProgressIndicator( color: Get.theme.primaryColor,);
        } else if (snapshot.hasError) {
          return const Text("Error");
        } else {
          return Column(children: [
            Column(children: [
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward, color: Get.theme.primaryColor),
                elevation: 16,
                style: TextStyle(color: Get.theme.primaryColor),
                underline: Container(
                  height: 2,
                  color: Get.theme.primaryColor,
                ),
                onChanged: onDropdownValueChange,
                items: buildList(),
              )
            ]),
            snapshot.data,
          ]);
        }
      }

  void onDropdownValueChange(String value) async {
          // This is called when the user selects an item.
          box.write("selectedConstituency", value);
          polls = await getAllPollData();
          setState(() {
            log(value);
            dropdownValue = value;
          });
        }

  Future<PollCardSection> buildPollCardSection() async {
    return PollCardSection(polls: polls, callback: () async{
      setState(() {
        loading = true;
      });
      await getAllPollData();
      setState(() {
        loading = false;
      });
    });
  }

  List<DropdownMenuItem<String>> buildList() => constituencies
      .map((e) =>
          new DropdownMenuItem<String>(value: e.constituencyKey, child: Text(e.name)))
      .toList();
}
