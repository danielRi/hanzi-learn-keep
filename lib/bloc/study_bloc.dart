import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/repo/stastic_repository.dart';

class StudyEvent {}

class InitEvent extends StudyEvent {
  final amountOfCharacters;
  InitEvent(this.amountOfCharacters);
}

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
  CharacterFrame characterFrame;
  bool covered;
  bool showHint = false;
  bool showPrimitive = false;
  CurrentFrame(this.characterFrame, [this.covered = true]);
}

class StudyState {}

class LoadingState extends StudyState {}

class CharacterState extends StudyState {
  CurrentFrame currentFrame;
  final List<CharacterFrame> framesToStudy;
  final List<String> correctFrames = List<String>();
  int index;
  CharacterState(this.currentFrame, this.framesToStudy, this.index);

  CharacterState copyWith(
      {bool covered, bool showHint, bool showPrimitive, int newIndex}) {
    if (covered != null) {
      currentFrame.covered = covered;
    }
    if (showHint != null) {
      currentFrame.showHint = showHint;
    }
    if (showPrimitive != null) {
      currentFrame.showPrimitive = showPrimitive;
    }
    if (newIndex != null) {
      index = newIndex;
      currentFrame = CurrentFrame(framesToStudy[newIndex]);
    }
    return CharacterState(currentFrame, framesToStudy, index);
  }
}

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc(int framesToStudy) : super(LoadingState());

  @override
  Stream<StudyState> mapEventToState(StudyEvent event) async* {
    final currentState = state;
    if (event is CheckEvent) {
      if (currentState is CharacterState) {
        if (event is CorrectEvent) {
          StatisticRepository().correct(event.frameId);
        } else if (event is WrongEvent) {
          StatisticRepository().wrong(event.frameId);
        }
        print("currentState.index: ${currentState.index.toString()}");
        final index = getNextIndex(currentState.framesToStudy,
            currentState.correctFrames, currentState.index);
        print("Index: ${index.toString()}");
        yield currentState.copyWith(newIndex: index);
      } else {
        addError(Exception("unexpected state"), StackTrace.current);
      }
    } else if (event is InitEvent) {
      final data = await CharacterRepository().fetchData();
      final framesToStudy =
          await initFramesToStudy(data, event.amountOfCharacters);
      print("framesToStudy: ${framesToStudy.toString()}");

      final startIndex = 0;
      yield CharacterState(CurrentFrame(framesToStudy[startIndex], true),
          framesToStudy, startIndex);
    } else if (event is ShowHintEvent) {
      if (currentState is CharacterState) {
        yield currentState.copyWith(showHint: true);
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
    print(change.currentState.runtimeType.toString());
    super.onChange(change);
  }

  void _onCorrectEvent(String frameId) {
    // TODO: save to stastic
  }

  void _onWrongEvent(String frameId) {
    // TODO: save to stastic
  }

  Future<List<CharacterFrame>> initFramesToStudy(
      Map<String, CharacterFrame> data, int amountOfCharacters) async {
    final lastindex = data.keys.toList().length - 1;
    final random = Random();
    final meaningfulList =
        await StatisticRepository().createSuitableStudyList(50);
    final resultList = List<CharacterFrame>();
    while (resultList.length < 50) {
      final randomIndex = random.nextInt(lastindex);
      String randomFrameId = data.keys.toList()[randomIndex];
      bool frameAlreadyExists = false;
      resultList.forEach((element) {
        if (element.frameNumber == randomFrameId) {
          frameAlreadyExists = true;
          return;
        }
      });
      if (frameAlreadyExists == false) {
        resultList.add(CharacterRepository().getFrame(randomFrameId));
      }
    }
    return resultList;
  }

  int getNextIndex(List<CharacterFrame> framesToStudy,
      List<String> correctIndexes, int currentIndex) {
    var nextIndex = currentIndex;
    do {
      if (currentIndex < framesToStudy.length - 1) {
        nextIndex++;
      } else {
        nextIndex = 0;
      }
    } while (correctIndexes.contains(framesToStudy[nextIndex].frameNumber));

    return nextIndex;
  }
}
