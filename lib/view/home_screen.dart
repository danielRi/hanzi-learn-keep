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
        child: Center(
          child: Text(
            "學",
            style: GoogleFonts.notoSerif(fontSize: 26.0),
          ),
        ),
        children: [
          SpeedDialChild(
            child: Center(child: Text("50")),
            backgroundColor: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyScreen(50)),
            ),
          ),
          SpeedDialChild(
            child: Center(
              child: Text(
                String.fromCharCode($infin),
              ),
            ),
            backgroundColor: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
