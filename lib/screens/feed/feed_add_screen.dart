import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/misc/profile_tile.dart';

class FeedAddScreen extends StatelessWidget {
  static const routeName = '/feedAdd';

  const FeedAddScreen({Key key}) : super(key: key);
  Widget attachments(String label, IconData icon, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
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
      margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
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

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Create Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text(
              "Post",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileTile(mediaQuery: _mediaQuery),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                ),
              ),
            ),
            attachmentHolder(_mediaQuery),
            attachments("Photo", Icons.photo_library, 0),
            attachments("Video", Icons.video_library, 0),
            attachments("Document", Icons.picture_as_pdf, 0),
          ],
        ),
      ),
    );
  }
}
