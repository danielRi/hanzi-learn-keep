import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';



class StudyEvent {}

class FetchDataEvent extends StudyEvent {}

class CheckEvent extends StudyEvent {
  final String frameId;
  CheckEvent(
    this.frameId,
  );
}

class CorrectEvent extends CheckEvent {
  CorrectEvent(String frameId) : super(frameId);
}

class WrongEvent extends CheckEvent {
  WrongEvent(String frameId) : super(frameId);
}

class CurrentFrame {
  final CharacterFrame currentFrame;
  bool covered;
  CurrentFrame(this.currentFrame, [this.covered = true]);
}

class StudyState {}

class LoadingState extends StudyState {}

class CharacterState extends StudyState {
  CurrentFrame currentFrame;
  final List<CharacterFrame> framesToStudy;
  CharacterState(
    this.currentFrame,
    this.framesToStudy,
  );
}

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc(int framesToStudy) : super(LoadingState());

  @override
  Stream<StudyState> mapEventToState(StudyEvent event) async* {
    if (event is CheckEvent) {
    } else if (event is FetchDataEvent) {
      final data = await CharacterRepository().fetchData();
      final framesToStudy = initFramesToStudy(data);
      print("framesToStudy: ${framesToStudy.toString()}");

      yield CharacterState(CurrentFrame(framesToStudy[0], true), framesToStudy);
    } else {
      yield state;
    }
  }

  @override
  void onChange(Change<StudyState> change) {
    print("onchange:");
    print(change);
    super.onChange(change);
  }

  void _onCorrectEvent(String frameId) {
    // TODO: save to stastic
  }

  void _onWrongEvent(String farmeId) {
    // TODO: save to stastic
  }

  List<CharacterFrame> initFramesToStudy(Map<String, CharacterFrame> data) {
    final lastindex = data.keys.toList().length - 1;
    final random = Random();
    final resultList = List<CharacterFrame>();
    for (int i = 0; i < 50; i++) {
      final randomIndex = random.nextInt(lastindex);
      String randomFrameId = data.keys.toList()[randomIndex];
      resultList.add(CharacterRepository().getFrame(randomFrameId));
    }
    return resultList;
  }
}
