import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/Announcement.dart';
import 'package:jaansay_public_user/models/constituency.dart';
import 'package:jaansay_public_user/service/announcements_service.dart';
import 'package:jaansay_public_user/service/questionnaire_service.dart';

class AnnouncementSection extends StatefulWidget {
  @override
  State<AnnouncementSection> createState() => _AnnouncementSectionState();
}

class _AnnouncementSectionState extends State<AnnouncementSection> {
  List<Constituency> constituencies = [];
  AnnouncementService announcementService = new AnnouncementService();
  QuestionnaireService _questionnaireService = QuestionnaireService();

  List<Announcement> announcements;
  GetStorage box = GetStorage();
  String dropdownValue;


  @override
  initState() {
    super.initState();
    getAllAnnoucements();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildAnnouncementsSection(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if(!snapshot.hasData) { // not loaded
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("Error");
        } else {
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
                onChanged: (String value) async {
                  // This is called when the user selects an item.
                  box.write("selectedConstituency", value);
                  announcements = await getAllAnnoucements();
                  setState(() {
                    log(value);
                    dropdownValue = value;
                  });
                },
                items: buildList(),
              )
            ]),
            snapshot.data,
          ]);
        }
      },

    );
  }

  Future<List<Announcement>> getAllAnnoucements() async{
    constituencies = await _questionnaireService.getConstituencies();
    String constituencyKey = box.read("selectedConstituency") ?? constituencies.first.constituencyKey;
    box.write("selectedConstituency", constituencyKey);
    dropdownValue = constituencyKey;
    log(constituencyKey);
    return await announcementService.getAllAnnouncements(constituencyKey);
  }

  Future<Widget> buildAnnouncementsSection() async {
    announcements = await getAllAnnoucements();
    return Column(
      children: announcements.map((announcement) {
        return Card(
          child: (
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text(announcement.description),
          )
          )
        );
      }).toList(),
    );
  }

  List<DropdownMenuItem<String>> buildList() => constituencies
      .map((e) =>
  new DropdownMenuItem<String>(value: e.constituencyKey, child: Text(e.name)))
      .toList();

}