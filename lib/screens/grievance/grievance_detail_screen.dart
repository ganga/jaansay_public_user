import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/grievance.dart';

class GrievanceDetailScreen extends StatefulWidget {
  final GrievanceMaster grievanceMaster;

  GrievanceDetailScreen(this.grievanceMaster);

  @override
  _GrievanceDetailScreenState createState() => _GrievanceDetailScreenState();
}

class _GrievanceDetailScreenState extends State<GrievanceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Grievance Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
