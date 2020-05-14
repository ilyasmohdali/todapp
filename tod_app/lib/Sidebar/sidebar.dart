import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget{
  @override
  SidebarState createState() => new SidebarState();
}


class SidebarState extends State<Sidebar>{

  final bool isSidebarOpened = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final animationDuration = const Duration(milliseconds: 500);


    return AnimatedPositioned(
      duration: animationDuration,
      top: 0,
      bottom: 0,
      left: isSidebarOpened ? 0 : 0,
      right: isSidebarOpened ? 0 : screenWidth - 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              //width: 150.0,
              height: double.infinity,
              color: Color(0xFF262AAA),
            ),
          ),
          Align(
            alignment: Alignment(0,-0.87),
            child: Container(
              width: 60.0,
              height: 60.0,
              color: Color(0xFF262AAA),
            ),
          )
        ],
      ),
    );
  }
}