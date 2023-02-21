import 'package:flutter/material.dart';
import 'package:flutter_project_02/main.dart';
import 'package:flutter_project_02/appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_project_02/expbtn.dart';
import 'package:filesize/filesize.dart';
import 'dart:convert';
import 'package:line_awesome_icons/line_awesome_icons.dart';

var fileList;
var dialFileList;

class OpenDTPage extends StatefulWidget{

  const OpenDTPage({
    Key key,
    this.indexDB = ""
  }) : super(key: key);
  final String indexDB;

  @override
  _OpenDTPageState createState() => new _OpenDTPageState();
}

class _OpenDTPageState extends State<OpenDTPage> {

  bool flag = false;

  _loadDBFile() async {
    fileList = await _getFileDB();
    flag = true;
 }

  @override
  Widget build(BuildContext context) {

    final bool _alreadySaved = saved.contains(widget.indexDB);

    return MaterialApp(
      title: '도시계획',
      theme: ThemeData(primarySwatch : Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: MainHome(
        child: AppBar(
          elevation: 1.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title : Text(widget.indexDB, style: TextStyle(fontSize: 20, color: Color(0xffD0D0D0))),
          leading: IconButton(
              iconSize: 33.0,
              icon: Icon(
                  Icons.arrow_back, color: Color(0xffE6E6E6)),
              onPressed: () {
                Navigator.of(context, rootNavigator: false).pop();
              }),
          actions: <Widget>[
            IconButton(
              iconSize: 35.0,
              icon: Icon(Icons.star,
                  color: _alreadySaved ? Color(0xffFFF200) : Color(0xffEBEBEB)),
              onPressed: () {
                setState(() {
                  if (_alreadySaved) {
                    saved.remove(widget.indexDB);
                    checkDelete = true;
                  } else {
                    saved.add(widget.indexDB);
                    checkDelete = false;
                  }
                });
                String tempBM = jsonEncode(saved);
                AccBMdb().saveBMdb(tempBM);
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _loadDBFile(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return flag ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left : 5, right: 5, top:7, bottom:5),
                      itemCount: fileList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                            height: 65,
                            child: FlatButton(
                              padding: EdgeInsets.only(left : 10, right: 0, top:0, bottom:0),
                              onPressed: (){
                                dialFileList = fileList[i];
                                _createAlertDialog(context);
                              },
                              child : Row(
                                children: <Widget>[
                                  Icon(LineAwesomeIcons.file_pdf_o, size: 35, color: Color(0xffFF6666)),
                                  Container(margin: EdgeInsets.only(left:5)),
                                  Expanded(
                                    child : Text(fileList[i]["FileName"],
                                      style: TextStyle(fontSize: 17, color:Colors.black),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left:5, right:5),
                                    child : Text(filesize(fileList[i]["FileSize"],0).toString(),
                                      style: TextStyle(fontSize: 12, color:Color(0xffE6E6E6)),
                                    ),
                                  ),
                                  Container(margin: EdgeInsets.only(left:0, right:5)),
                                ],
                              ),
                            )
                        );
                      }
                  ),
                ),
                Text("출처 : 해당 정부기관 및 지자체", style: TextStyle(fontSize: 11, color:Color(0xffE6E6E6))),
                Container(margin: EdgeInsets.only(bottom:5)),
              ],
            )
            : Center (
                  child : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE6E6E6)),
                  )
                );
          },
        ),
      ),
    );
  }
  _getFileDB() async{

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "active_db.db");
    ByteData data = await rootBundle.load(join("assets", "file_db_v1.3.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    Database db = await openDatabase(path);
    var fileInfo = await db.rawQuery('SELECT * FROM file_db WHERE SubTitle = ?', [widget.indexDB]);

    return fileInfo;
  }

  _createAlertDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context, builder: (context){
      return CustomDialog();
    });
  }
}


class CustomDialog extends StatefulWidget{

  @override
  _CustomDialogState createState() => new _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  bool downloading = false;
  var progressString = "";
  var name = "";

  @override
  void initState() {
    super.initState();
    _downloadFile();
  }

  @override
  BuildContext get context => super.context;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: EdgeInsets.all(20),
      title: Text(name),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: 160,
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child : downloading ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE6E6E6)),
              ): null,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("다운로드 $progressString"),
            Text(downloading ? "(다운로드가 완료되면 파일이 열립니다)": "")
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 5.0,
          child: Text(downloading ? "취소" : "닫기"),
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }

  _downloadFile() async {

    CancelToken cancelToken = CancelToken();

    final fileId = dialFileList["FileId"];
    final fileURL = "https://drive.google.com/uc?export=download&id="+fileId;
    int sizeofLoad = 0;
    int sizeofFile = dialFileList["FileSize"];

    Dio dio = Dio();

    var dir = await getApplicationDocumentsDirectory();

    var name = dialFileList["FileName"];
    var fileRoute = "${dir.path}/files/$name.pdf";
    var fileToOpen = File(fileRoute);
    bool fileCheck = await fileToOpen.exists();

    if (fileCheck) {
      sizeofLoad = fileToOpen.lengthSync();
    } else {
      sizeofLoad = 0;
    }

    if(!mounted) {
       cancelToken.cancel();
    }

    if (sizeofLoad == sizeofFile) {
      OpenFile.open(fileRoute);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      if(mounted) {
        setState(() {
          downloading = true;
          progressString = "파일준비중..";
        });
      }
      try {
        await dio.download(
          fileURL, fileRoute,
          onReceiveProgress: (rec, t) {
            if(mounted) {
              setState(() {
                progressString =
                    ((rec / sizeofFile) * 100).toStringAsFixed(0) + "%";
              });
            } else {
              cancelToken.cancel();
            }
          },
          cancelToken: cancelToken
          );
      } catch (e) {
      }
      if(mounted) {
        OpenFile.open(fileRoute);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}


// 1MB = 1,048,576B