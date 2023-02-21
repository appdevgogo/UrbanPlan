import 'package:flutter/material.dart';
import 'package:flutter_project_02/main.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:filesize/filesize.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';


class OpenSFPage extends StatefulWidget{

  @override
  _OpenSFPageState createState() => new _OpenSFPageState();
}

class _OpenSFPageState extends State<OpenSFPage> {

  List savedFList = [];
 // List savedFCB = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '도시계획',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: MainHome(
          child: AppBar(
            title: Text("저장된 파일",
                style: TextStyle(fontSize: 20, color: Color(0xffD0D0D0))),
            elevation: 1.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
                iconSize: 33.0,
                icon: Icon(
                    Icons.arrow_back, color: Color(0xffE6E6E6)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ),
          body: FutureBuilder(
              future: _savedFile(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return ListView.builder(
                    padding: EdgeInsets.only(left : 5, right: 5, top:7, bottom:5),
                    itemCount: savedFList.length,
                    itemBuilder: (BuildContext context, int i) {
                      final savedFString = _savedFString(i);
                      final savedFSize = _savedFSize(i);
                   //   final bool _alreadySaved = savedFCB.contains(savedFString);
                      return Container(
                        height: 65,
                          child: FlatButton(
                          padding: EdgeInsets.only(left : 0, right: 0, top:0, bottom:0),
                             onPressed: (){
                               _savedFOpen(savedFString);
                              },
                          child : Row(
                              children: <Widget>[
                                /*
                                IconButton(
                                    icon : Icon(_alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
                                        size: 23,
                                        color: _alreadySaved ? Colors.deepOrange : Color(0xffE6E6E6)),
                                onPressed: (){
                                  setState(() {
                                    if(_alreadySaved) {
                                      savedFCB.remove(savedFString);
                                    } else
                                      savedFCB.add(savedFString);
                                  });
                                }),
                                 */

                                Icon(LineAwesomeIcons.file_pdf_o, size: 35, color: Color(0xffFF6666)),
                                Container(margin: EdgeInsets.only(left:5)),
                                Expanded(
                                  child : Text(savedFString,
                                    style: TextStyle(fontSize: 17, color:Colors.black),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left:5, right:5),
                                  child : Text(filesize(savedFSize, 0).toString(),
                                    style: TextStyle(fontSize: 12, color:Color(0xffE6E6E6)),
                                  ),
                                ),
                                IconButton(
                                    icon : Icon(Icons.close, size: 28, color: Color(0xffE6E6E6)),
                                    onPressed: (){
                                      _savedFDelete(savedFString);
                                      setState(() {
                                        savedFList.removeAt(i);
                                      });
                                    }),
                              ],
                            ),
                          )
                      );
                    }
                );
              })
      ),
    );
  }

  _savedFString(i) {
    final str = savedFList[i].toString();
    final start = "files/";
    final end = ".pdf";
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    return str.substring(startIndex + start.length, endIndex);
  }

  _savedFSize(i) {
    return savedFList[i].lengthSync();
  }

  _savedFile() async {
     var dir = await getApplicationDocumentsDirectory();
     var savedFileDRoute = io.Directory("${dir.path}/files/");
     savedFList = savedFileDRoute.listSync();
  }
  _savedFOpen(name) async {
    var dir = await getApplicationDocumentsDirectory();
    var savedFileRoute = "${dir.path}/files/$name.pdf";
    await OpenFile.open(savedFileRoute);
  }
  _savedFDelete(name) async {
    var dir = await getApplicationDocumentsDirectory();
    var savedFileRoute = "${dir.path}/files/$name.pdf";
    await File(savedFileRoute).delete();
  }
}


