import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_search_dialog.dart';

class GrievanceScreen extends StatelessWidget {
  Widget attachments(String label, IconData icon, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 16,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget attachmentHolder(Size mediaQuery) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          Container(
            height: mediaQuery.height * 0.1,
            width: mediaQuery.height * 0.1,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Icon(Icons.photo),
          )
        ],
      ),
    );
  }

  selectUser(double height, double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("No user selected"),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  content: GrievanceSearchDialog(),
                ),
              );
            },
            child: Text(
              "Select User",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectUser(_mediaQuery.height, _mediaQuery.width, context),
              TextField(
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Type your grievance here",
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Please add anyone one of the following details.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              attachments("Location", Icons.location_on, 0),
              attachments("Photo", Icons.photo_library, 0),
              attachments("Video", Icons.video_library, 0),
              attachments("Document", Icons.picture_as_pdf, 0),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {},
                  child: Text(
                    "Send",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
