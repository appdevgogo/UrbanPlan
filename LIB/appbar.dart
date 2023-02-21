import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter_project_02/search.dart';
import 'package:flutter_project_02/bookmark.dart';
import 'package:flutter_project_02/saved.dart';

final List<String> sList = List<String>();
bool checkDelete = false;
bool flagR = true;

class MainAppBar extends StatefulWidget{

  @override
  MainAppBarState createState() => MainAppBarState();
}

class MainAppBarState extends State<MainAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1.0,
      centerTitle: false,
      backgroundColor: Colors.white,
      title : Row(
        children: <Widget>[
          IconButton(
              iconSize: 35.0,
              icon: Icon(Icons.star, color: Color(0xffE6E6E6)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => OpenBMPage()),
                );
              }),
          IconButton(
              iconSize: 35.0,
              icon: Icon(LineAwesomeIcons.download, color: Color(0xffE6E6E6)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => OpenSFPage()),
                );
              }),
        ],
      ),

      actions: <Widget>[
        IconButton(
          iconSize: 35.0,
          icon: Icon(Icons.search, color: Color(0xffE6E6E6)),
          onPressed: () {
            showSearch(context: context, delegate: OpenSRPage());
          },
        ),
      ],
      titleSpacing: 5.0,
    //  title: Text("도시계획" , style: TextStyle(color: Color(0xffD0D0D0))),
    );
  }
}




