import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StudyScreen extends StatelessWidget {
  final int framesToStudy;

  static const paperColor = Color.fromARGB(255, 241, 240, 235);

  StudyScreen([this.framesToStudy]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            return StudyBloc(framesToStudy)..add(FetchDataEvent());
          },
          child: BlocBuilder<StudyBloc, StudyState>(
            builder: (context, state) {
              if (state is CharacterState) {
                return AnimatedCrossFade(
                  duration: Duration(milliseconds: 200),
                  firstChild: _buildCoveredWidget(state.currentFrame, context),
                  secondChild: _buildUncoveredWidget(state.currentFrame),
                  crossFadeState: state?.currentFrame?.covered ?? false
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                );
              } else if (state is LoadingState) {
                return Center(
                  child: SpinKitPouringHourglass(color: Colors.black),
                );
              } else {
                return Center(
                  child: SpinKitPouringHourglass(color: Colors.black),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoveredWidget(CurrentFrame currentFrame, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // uncover
        print("uncover");
        BlocProvider.of<StudyBloc>(context).add(UnCoverEvent());
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: paperColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Text(
                    currentFrame.currentFrame.keyWord,
                    style: TextStyle(fontSize: 48, fontFamily: "FreeSerif"),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Text(
                    currentFrame.currentFrame.hint,
                    style: TextStyle(fontSize: 22, fontFamily: "FreeSerif"),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildUncoveredWidget(CurrentFrame currentFrame) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: paperColor,
        ),
        child: Center(
          child: Text(
            currentFrame.currentFrame.characterTraditional,
            style: TextStyle(
              fontSize: 200,
              fontFamily: "SentyWen",
            ),
          ),
        ),
      ),
    );
  }
}
