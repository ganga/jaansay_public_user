import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/community/officials_list_group.dart';

class OfficialListScreen extends StatefulWidget {
  @override
  _OfficialListScreenState createState() => _OfficialListScreenState();
}

class _OfficialListScreenState extends State<OfficialListScreen> {
  String title = "Business";

  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;

    if (type == 'appointed') {
      title = "Appointed Officials and Elected Members";
    } else if (type == 'association') {
      title = "Associations and Bodies";
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: _mediaQuery.width * 0.08,
                    vertical: _mediaQuery.height * 0.05),
                alignment: Alignment.center,
                child: AutoSizeText(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 26),
                  maxLines: 1,
                ),
              ),
            ),
            OfficialsListGroup(type),
            OfficialsListGroup(type),
            OfficialsListGroup(type),
          ],
        ),
      ),
    );
  }
}
