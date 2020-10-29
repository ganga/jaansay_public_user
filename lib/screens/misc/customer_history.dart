import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/misc/profile_tile.dart';
class CustomerHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body:Column(
        children: [
          ProfileTile(mediaQuery: MediaQuery.of(context).size,),
          Expanded(child: ListView.builder(itemBuilder: (context,index){
            return ListTile(
              title: Text("Rs. 25000"),
              subtitle: Text("12-10-1999"),
            );
          },itemCount: 10,))
        ],
      ),
    );
  }
}
