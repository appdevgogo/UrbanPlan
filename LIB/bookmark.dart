import 'package:flutter/material.dart';
import 'package:flutter_project_02/main.dart';
import 'package:flutter_project_02/expbtn.dart';
import 'package:flutter_project_02/detail.dart';

class OpenBMPage extends StatefulWidget{

  @override
  _OpenBMPageState createState() => new _OpenBMPageState();
}

class _OpenBMPageState extends State<OpenBMPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '도시계획',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: MainHome(
          child: AppBar(
            title: Text("북마크",
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
          body: ListView.builder(
              padding: EdgeInsets.symmetric(vertical : 5.0),
              itemCount: saved.length,
              itemBuilder: (context, i) {
                saved.sort();
                return Container(
                  margin: EdgeInsets.only(left:0, right:0, top:5, bottom:5),
                  child : FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => OpenDTPage(indexDB: saved[i])),
                        ).then((res) => _refreshBM());
                      },
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(saved[i], style: TextStyle(fontSize: 20)),
                          IconButton(
                              padding: EdgeInsets.only(left: 20),
                              icon: Icon(Icons.close, size: 28, color: Color(0xffE6E6E6)),
                              onPressed: () {
                                setState(() {
                                  saved.removeAt(i);
                                });
                              }
                          )
                        ],
                      )
                  ),
                );
              }
          )
      ),
    );
  }
  _refreshBM() {
    setState(() {
      saved.sort();
    });
  }
}
