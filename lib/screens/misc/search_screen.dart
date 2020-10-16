import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: TextField(
          autofocus: true,
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            child: Hero(
              tag: "search_icon",
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: Icon(
                  Icons.search,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
