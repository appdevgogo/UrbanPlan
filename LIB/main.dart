import 'package:flutter/material.dart';
import 'package:flutter_project_02/appbar.dart';
import 'package:flutter_project_02/expbtn.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool mainFlag = false;

  final List<SubMenu> subMenuB = [
    SubMenu(
      '국토종합계획',
      [],
    ),
    SubMenu(
      '서울특별시',
      ['서울 강남구', '서울 강동구', '서울 강북구', '서울 강서구', '서울 관악구',
        '서울 광진구', '서울 구로구', '서울 금천구', '서울 노원구', '서울 도봉구',
        '서울 동대문구', '서울 동작구', '서울 마포구', '서울 서대문구', '서울 서초구',
        '서울 성동구', '서울 성북구', '서울 송파구', '서울 양천구', '서울 영등포구',
        '서울 용산구', '서울 은평구', '서울 종로구', '서울 중구', '서울 중랑구'],
    ),
    SubMenu(
      '경기도',
      ['경기 가평군', '경기 고양시', '경기 과천시', '경기 광명시', '경기 광주시', '경기 구리시',
        '경기 군포시', '경기 김포시', '경기 남양주시', '경기 동두천시', '경기 부천시', '경기 성남시',
        '경기 수원시', '경기 시흥시', '경기 안산시', '경기 안성시', '경기 안양시', '경기 양주시',
        '경기 양평군', '경기 여주시', '경기 연천군', '경기 오산시', '경기 용인시', '경기 의왕시',
        '경기 의정부시', '경기 이천시', '경기 파주시', '경기 평택시', '경기 포천시', '경기 하남시'],
    ),
    SubMenu(
      '인천광역시',
      ['인천 강화군', '인천 계양구', '인천 남동구', '인천 동구', '인천 미추홀구', '인천 부평구',
        '인천 서구', '인천 연수구', '인천 옹진군', '인천 중구'],
    ),
    SubMenu(
      '부산광역시',
      ['부산 강서구', '부산 금정구', '부산 기장군', '부산 남구', '부산 동구', '부산 동래구', '부산 진구',
        '부산 북구', '부산 사상구', '부산 사하구', '부산 서구', '부산 수영구', '부산 연제구',
        '부산 영도구', '부산 중구', '부산 해운대구'],
    ),
    SubMenu(
      '대구광역시',
      ['대구 남구', '대구 달서구', '대구 달성군', '대구 동구', '대구 북구', '대구 서구',
       '대구 수성구', '대구 중구'],
    ),
    SubMenu(
      '대전광역시',
      ['대전 대덕구', '대전 동구', '대전 서구', '대전 유성구', '대전 중구'],
    ),
    SubMenu(
      '광주광역시',
      ['광주 광산구', '광주 남구', '광주 동구', '광주 북구', '광주 서구'],
    ),
    SubMenu(
      '울산광역시',
      ['울산 남구', '울산 동구', '울산 북구', '울산 울주군', '울산 중구'],
    ),
    SubMenu(
      '세종특별자치시',
      [],
    ),
    SubMenu(
      '충청북도',
      ['충북 괴산군', '충북 단양군', '충북 보은군', '충북 영동군', '충북 옥천군', '충북 음성군',
        '충북 제천시', '충북 증평군', '충북 진천군', '충북 청주시', '충북 충주시'],
    ),
    SubMenu(
      '충청남도',
      ['충남 계룡시', '충남 공주시', '충남 금산군', '충남 논산시', '충남 당진시',
        '충남 보령시', '충남 부여군', '충남 서산시', '충남 서천군', '충남 아산시',
        '충남 예산군', '충남 천안시', '충남 청양군', '충남 태안군', '충남 홍성군'],
    ),
    SubMenu(
      '경상북도',
      ['경북 경산시', '경북 경주시', '경북 고령군', '경북 구미시', '경북 군위군', '경북 김천시',
        '경북 문경시', '경북 봉화군', '경북 상주시', '경북 성주군', '경북 안동시', '경북 영덕군',
        '경북 영양군', '경북 영주시', '경북 영천시', '경북 예천군', '경북 울릉군', '경북 울진군',
        '경북 의성군', '경북 청도군', '경북 청송군', '경북 칠곡군', '경북 포항시'],
    ),
    SubMenu(
      '경상남도',
      ['경남 거제시', '경남 거창군', '경남 고성군', '경남 김해시', '경남 남해군', '경남 밀양시',
        '경남 사천시', '경남 산청군', '경남 양산시', '경남 의령군', '경남 진주시', '경남 창년군',
        '경남 창원시', '경남 통영시', '경남 하동군', '경남 함안군', '경남 함양군', '경남 합천군',
      ],
    ),
    SubMenu(
      '전라북도',
      ['전북 고창군', '전북 군산시', '전북 김제시', '전북 남원시', '전북 무주군',
        '전북 부안군', '전북 순창군', '전북 완주군', '전북 익산시', '전북 임실군',
        '전북 장수군', '전북 전주시', '전북 정읍시', '전북 진안군'],
    ),
    SubMenu(
      '전라남도',
      ['전남 강진군', '전남 고흥군', '전남 곡성군', '전남 광양시', '전남 구례군', '전남 나주시',
        '전남 담양군', '전남 목포시', '전남 무안군', '전남 보성군', '전남 순천시', '전남 신안군',
        '전남 여수시', '전남 영광군', '전남 영암군', '전남 완도군', '전남 장성군', '전남 장흥군',
        '전남 진도군', '전남 함평군', '전남 해남군', '전남 화순군',],
    ),
    SubMenu(
      '강원도',
      ['강원 강릉시', '강원 고성군', '강원 동해시', '강원 삼척시', '강원 속초시', '강원 양구군',
        '강원 양양군', '강원 영월군', '강원 원주시', '강원 인제군', '강원 정선군', '강원 철원군',
        '강원 춘천시', '강원 태백시', '강원 평창군', '강원 홍천군', '강원 화천군', '강원 횡성군',
      ],
    ),
    SubMenu(
      '제주특별자치도',
      ['제주 제주시', '제주 서귀포시'],
    ),
  ];

  void _simpleList() {
    for (int i=0; i < subMenuB.length; i++) {
      sList.add(subMenuB[i].title);
      for (int j=0; j < subMenuB[i].contents.length; j++){
      sList.add(subMenuB[i].contents[j]);
     }
    }
  }

  _loadBMdb() async {
    try {
      final file = await AccBMdb()._localFile;
      String bmTxt = await file.readAsString();
      final List<String> bmList = (json.decode(bmTxt)).cast<String>();
      saved = bmList;
    } catch (e) {
    }
    mainFlag = true;
  }

  @override
  void initState() {
    super.initState();
    _simpleList();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '도시계획',
      theme: ThemeData(
        primarySwatch : Colors.deepOrange,
        cursorColor: Colors.black45,
        appBarTheme: AppBarTheme(
          elevation: 1.0,
        )
      ),
      home: MainHome(
        child: MainAppBar(),
        body: FutureBuilder(
          future: _loadBMdb(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return mainFlag ? ExpBtnSD(submenu: subMenuB) : Center (
              child : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE6E6E6)),
              )
            );
          }
        )
      ),
    );
  }
}

class MainHome extends StatelessWidget{

  const MainHome({
    Key key,
    this.child,
    this.body,
  }) : super(key: key);
  final child;
  final body;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: child,
      ),
      body: body,
    );
  }
}

class SubMenu {
  final String title;
  List<String> contents = [];

  SubMenu(this.title, this.contents);
}

class AccBMdb {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bm_db.txt');
  }

  Future<File> saveBMdb(text) async {
    final file = await _localFile;
    return file.writeAsString('$text');
  }
}


