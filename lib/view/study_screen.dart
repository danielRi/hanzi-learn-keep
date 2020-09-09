import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';

import '../bloc/study_bloc.dart';

class StudyScreen extends StatelessWidget {
  final int framesToStudy;

  StudyScreen([this.framesToStudy]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return StudyBloc(framesToStudy);
        },
        child: BlocBuilder<StudyBloc, StudyState>(
          builder: (context, state) {
            return AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              firstChild: _buildCoveredWidget(),
              secondChild: _buildUncoveredWidget(),
              crossFadeState: state.currentFrame.covered
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCoveredWidget() {
    return GestureDetector(
      onTap: () {
        // TODO: uncover
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
