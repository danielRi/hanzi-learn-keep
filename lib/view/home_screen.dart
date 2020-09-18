import "package:charcode/charcode.dart";
import "package:charcode/html_entity.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzi_learn_keep/view/study_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.black,
        child: Center(
          child: Text(
            "學",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "SentyWen",
            ),
          ),
        ),
        children: [
          SpeedDialChild(
            child: Center(
              child: Text(
                "50",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "SentyWen",
                ),
              ),
            ),
            backgroundColor: Colors.black,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyScreen(50)),
            ),
          ),
          SpeedDialChild(
            child: Center(
              child: Text(
                "20",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "SentyWen",
                ),
              ),
            ),
            backgroundColor: Colors.black,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyScreen(20)),
            ),
          ),
        ],
      ),
    );
  }
}
