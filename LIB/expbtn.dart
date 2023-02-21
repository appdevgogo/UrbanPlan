import 'package:flutter/material.dart';
import 'package:flutter_project_02/main.dart';
import 'package:flutter_project_02/detail.dart';
import 'package:flutter_project_02/appbar.dart';
import 'dart:convert';

List<String> saved = List<String>();

class ExpBtnSD extends StatefulWidget {

  const ExpBtnSD({
    Key key,
    this.submenu = const <SubMenu>[],
  }) :
        super(key: key);
  final List<SubMenu> submenu;

  @override
  _ExpBtnSDState createState() => _ExpBtnSDState();
}

class _ExpBtnSDState extends State<ExpBtnSD> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical : 5.0),
      itemCount: widget.submenu.length,
      itemBuilder: (context, i) {
        return ExpBtnDT(
          subtext: widget.submenu[i].title,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.submenu[i].contents.length,
              itemBuilder: (BuildContext context, int j) {
                final bool _alreadySaved = saved.contains(widget.submenu[i].contents[j]);
                return Container(
                  margin: EdgeInsets.only(left:50, right:50, top:2, bottom:8),
                  child: FlatButton(
                    color: Color(0xffFFF2CC),
                    padding: EdgeInsets.only(left: 0.0),
                    shape : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => OpenDTPage(indexDB: widget.submenu[i].contents[j])),
                        ).then((res) => _checkHD());
                      },
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Container(
                        margin: EdgeInsets.only(left:10),
                        child : IconButton(
                          icon: Icon(Icons.star,
                              size: 29,
                              color: _alreadySaved ? Color(0xffFFF200) : Color(0xffFFE9AB)),
                          onPressed: () {
                            setState(() {
                              if (_alreadySaved) {
                                saved.remove(widget.submenu[i].contents[j]);
                              } else {
                                saved.add(widget.submenu[i].contents[j]);
                              }
                            });
                            String tempBM = jsonEncode(saved);
                            AccBMdb().saveBMdb(tempBM);
                          },
                        ),
                      ),
                      Text(widget.submenu[i].contents[j],
                          style: TextStyle(fontSize: 19, color: Colors.black87)),
                      Container(margin: EdgeInsets.only(left:50)),
                    ]
                  )
                  )
                );
              }
            ),
          ],
        );
      },
    );
  }
}

const Duration _kExpand = Duration(milliseconds: 0);

class ExpBtnDT extends StatefulWidget {

  const ExpBtnDT({
    Key key,
    this.subtext = '',
    this.children = const <Widget>[],
    this.onExpansionChanged,
    this.initiallyExpanded = false,
  }) : assert(initiallyExpanded != null),
        super(key: key);

  final String subtext;
  final List<Widget> children;
  final ValueChanged<bool> onExpansionChanged;
  final bool initiallyExpanded;

  @override
  _ExpBtnDTState createState() => _ExpBtnDTState();
}

class _ExpBtnDTState extends State<ExpBtnDT> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded = false;
  bool _isExpandable = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded)
      _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted)
            return;
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }

  Widget _buildChildren(BuildContext context, Widget child) {

    final bool _alreadySaved = saved.contains(widget.subtext);

      if ((widget.subtext == "국토종합계획")||(widget.subtext == "세종특별자치시")) {
        _isExpandable = false;
      } else {
        _isExpandable = true;
      }

    return Column(
      children: <Widget>[
        Container(
          child :
          SizedBox(
            height: 60,
            child : Container(
              decoration: BoxDecoration(
                border : Border(
                  top: BorderSide(width: 1, color: widget.subtext == "국토종합계획"? Colors.transparent : Color(0xffF0F0F0)),
                ),
              ),
              child: FlatButton(
                padding: EdgeInsets.only(top: 3.0),
                color : Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => OpenDTPage(indexDB: widget.subtext)),
                  ).then((res) => _checkHD());
                },
                child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Container(
                        margin : EdgeInsets.only(left:10),
                        child: IconButton(
                            icon: Icon(Icons.star,
                                size: 30,
                                color: _alreadySaved ? Color(0xffFFF200) : Color(0xffEBEBEB)),
                            onPressed: (){
                              setState(() {
                                if(_alreadySaved) {
                                  saved.remove(widget.subtext);
                                } else
                                  saved.add(widget.subtext);
                              });
                              String tempBM = jsonEncode(saved);
                              AccBMdb().saveBMdb(tempBM);
                            },
                        ),
                      ),
                      Text(widget.subtext,
                            style: TextStyle(fontSize: 20, color:Colors.black),
                            textAlign: TextAlign.center),
                      Container(
                          margin : EdgeInsets.only(right:10),
                          child : IconButton(
                              icon: Icon(
                                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: _isExpandable ? Color(0xffD9D9D9) : Colors.transparent),
                              onPressed: _isExpandable ? _handleTap : null
                          ),
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }
}

_checkHD() {
  checkDelete = false;
}