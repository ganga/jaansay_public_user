import 'package:flutter/material.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_file_attach.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:provider/provider.dart';

class ReplyBottomSheet extends StatefulWidget {
  @override
  _ReplyBottomSheetState createState() => _ReplyBottomSheetState();
}

class _ReplyBottomSheetState extends State<ReplyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            LongTextField(
              controller: grievanceProvider.controller,
              hint: "Enter your comment here",
            ),
            const SizedBox(
              height: 8,
            ),
            GrievanceFileAttachSection(),
            ElevatedButton(
              onPressed: () {
                grievanceProvider.addComment();
              },
              child: Text("Add Comment"),
            ),
          ],
        ),
      ),
    );
  }
}
