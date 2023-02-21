import 'package:flutter/material.dart';
import 'package:flutter_project_02/main.dart';
import 'package:flutter_project_02/appbar.dart';
import 'package:flutter_project_02/expbtn.dart';
import 'package:flutter_project_02/detail.dart';
import 'dart:convert';


class OpenSRPage extends SearchDelegate<String>  {

  final _list = sList;
  final _recentList = [];

  @override
  String get searchFieldLabel => '검색.. ex)서울특별시 or 수원시';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Color(0xffE3E3E3), fontSize: 18.0)),
      primaryColor: Colors.white,
      primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.black, fontSize: 18.0)
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        iconSize: 28.0,
        icon : Icon(
            Icons.cancel,
            color: query == "" ? Color(0xffFFFFFF) : Color(0xffE6E6E6)),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        iconSize: 33.0,
        icon: Icon(Icons.arrow_back, color: Color(0xffE6E6E6)),
        onPressed:(){
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final suggestionList = query.isEmpty
        ? _recentList
        : _list.where((p) => p.contains(query)).toList();

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
              margin : EdgeInsets.only(left:0, right:0, top:10, bottom:5),
              child : ListView.builder(
                  itemCount: suggestionList.length,
                  itemBuilder: (context, i) {
                    final bool _alreadySaved = saved.contains(suggestionList[i]);
                    return Container(
                      margin : EdgeInsets.only(left:0, right:0, top:5, bottom:5),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => OpenDTPage(indexDB: suggestionList[i])),
                          );
                        },
                        child: Row(
                            children: <Widget>[
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.star,
                                      size: 30,
                                      color: _alreadySaved ? Color(0xffFFF200) : Color(
                                          0xffEBEBEB)),
                                  onPressed: () {
                                    setState(() {
                                      if (_alreadySaved) {
                                        saved.remove(suggestionList[i]);
                                      } else {
                                        saved.add(suggestionList[i]);}
                                    });
                                    String tempBM = jsonEncode(saved);
                                    AccBMdb().saveBMdb(tempBM);
                                  }
                              ),
                              Container(margin: EdgeInsets.only(left: 6)),
                              Text(suggestionList[i],
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                  textAlign: TextAlign.left),
                              Container(margin: EdgeInsets.only(left: 5)),
                            ]
                        ),
                      ),
                    );
                  })
          );
        }
    );
  }
}