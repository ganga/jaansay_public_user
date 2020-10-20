import 'package:flutter/material.dart';

class GrievanceSearchDialog extends StatelessWidget {
  _searchField(double height, double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.02),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.05)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  decoration:
                      InputDecoration.collapsed(hintText: "Enter user name"),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              height: double.infinity,
              width: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      width: _mediaQuery.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchField(_mediaQuery.height, _mediaQuery.width, context),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container();
              },
              itemCount: 16,
            ),
          )
        ],
      ),
    );
  }
}
