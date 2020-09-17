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

class ShowHintEvent extends StudyEvent {}

class UnCoverEvent extends StudyEvent {}

class ShowPrimitiveEvent extends StudyEvent {}

class CurrentFrame {
  final CharacterFrame currentFrame;
  bool covered;
  bool showHint = false;
  bool showPrimitive = false;
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

  CharacterState copyWith({bool covered, bool showHint, bool showPrimitive}) {
    if (covered != null) {
      currentFrame.covered = covered;
    }
    if (showHint != null) {
      currentFrame.showHint = showHint;
    }
    if (showPrimitive != null) {
      currentFrame.showPrimitive = showPrimitive;
    }

    return CharacterState(currentFrame, framesToStudy);
  }
}

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc(int framesToStudy) : super(LoadingState());

  @override
  Stream<StudyState> mapEventToState(StudyEvent event) async* {
    final currentState = state;
    if (event is CheckEvent) {
    } else if (event is FetchDataEvent) {
      final data = await CharacterRepository().fetchData();
      final framesToStudy = initFramesToStudy(data);
      print("framesToStudy: ${framesToStudy.toString()}");

      yield CharacterState(CurrentFrame(framesToStudy[0], true), framesToStudy);
    } else if (event is ShowHintEvent) {
      if (currentState is CharacterState) {
        currentState.currentFrame.showHint = true;
        yield currentState;
      } else {
        addError(Exception("unexpected state"), StackTrace.current);
      }
    } else if (event is ShowPrimitiveEvent) {
      if (currentState is CharacterState) {
        currentState.currentFrame.showPrimitive = true;
        yield currentState;
      } else {
        addError(Exception("unexpected state"), StackTrace.current);
      }
    } else if (event is UnCoverEvent) {
      if (currentState is CharacterState) {
        yield currentState.copyWith(covered: false);
      } else {
        addError(Exception("unexpected state"), StackTrace.current);
      }
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
