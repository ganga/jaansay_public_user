// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_file_attach.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';

class GrievanceAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Add Grievance",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [_AddSection()],
          ),
        ),
      ),
    );
  }
}

class _AddSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Text(
                "Enter your grievance in detail, also attach necessary files."),
            const SizedBox(
              height: 8,
            ),
            LongTextField(
              controller: grievanceProvider.controller,
              hint: "Enter your grievance here",
            ),
            const SizedBox(
              height: 8,
            ),
            GrievanceFileAttachSection(),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  grievanceProvider.addGrievanceMaster();
                },
                child: Text("Add Grievance"))
          ],
        ),
      ),
    );
  }
}
