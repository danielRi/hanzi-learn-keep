import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StudyScreen extends StatelessWidget {
  final int framesToStudy;

  StudyScreen([this.framesToStudy]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return StudyBloc(framesToStudy)..add(FetchDataEvent());
        },
        child: BlocBuilder<StudyBloc, StudyState>(
          builder: (context, state) {
            if (state is CharacterState) {
              return AnimatedCrossFade(
                duration: Duration(milliseconds: 200),
                firstChild: _buildCoveredWidget(state.currentFrame),
                secondChild: _buildUncoveredWidget(),
                crossFadeState: state?.currentFrame?.covered ?? false
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            } else if (state is LoadingState) {
              return Center(
                child: SpinKitPouringHourglass(color: Colors.black),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCoveredWidget(CurrentFrame currentFrame) {
    return GestureDetector(
      onTap: () {
        // TODO: uncover
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 240, 235),
        ),
        child: Center(
          child: Text(
            currentFrame.currentFrame.characterTraditional,
            style: GoogleFonts.lato(fontSize: 200.0),
          ),
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
