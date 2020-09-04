import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  bool unCovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudyBloc, StudyState>(
        cubit: StudyBloc(null),
        builder: (context, state) {
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            firstChild: _buildCoveredWidget(),
            secondChild: _buildUncoveredWidget(),
            crossFadeState: unCovered
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          );
        },
      ),
    );
  }

  Widget _buildCoveredWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          unCovered = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildUncoveredWidget() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
      ),
    );
  }
}
