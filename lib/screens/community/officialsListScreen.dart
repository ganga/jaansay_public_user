import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/community/officialsListGroup.dart';

class OfficialListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

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
                child: AutoSizeText(
                  "Appointed Officials and Elected Members",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                  maxLines: 1,
                ),
              ),
            ),
            OfficialsListGroup(),
            OfficialsListGroup(),
            OfficialsListGroup(),
          ],
        ),
      ),
    );
  }
}
