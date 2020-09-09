import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hanzi_learn_keep/model/character_frame.dart';

import 'package:hanzi_learn_keep/service/hanzi_parser_service.dart';

class StudyEvent {
  final String frameId;
  StudyEvent(
    this.frameId,
  );
}

class CorrectEvent extends StudyEvent {
  CorrectEvent(String frameId) : super(frameId);
}

class WrongEvent extends StudyEvent {
  WrongEvent(String frameId) : super(frameId);
}

class CurrentFrame {
  final CharacterFrame currentFrame;
  bool covered;
  CurrentFrame(this.currentFrame, [this.covered = true]);
}

class StudyState {
  final CurrentFrame currentFrame;
  final LinkedHashMap<String, bool> framesToStudy;
  StudyState(
    this.currentFrame,
    this.framesToStudy,
  );
}

class InitialState extends StudyState {
  InitialState(
      CurrentFrame currentFrame, LinkedHashMap<String, bool> framesToStudy)
      : super(currentFrame, framesToStudy);

  factory InitialState.withFramesToStudy(int framesToStudy) {
    // TODO get repo and create Frames
    HanziParserService().getDataFromJson();
    print(
        "You want to study ${framesToStudy?.toString() ?? "infinite"} Frames");

    return InitialState(null, null);
  }
}

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc(int framesToStudy)
      : super(InitialState.withFramesToStudy(framesToStudy));

  @override
  Stream<StudyState> mapEventToState(StudyEvent event) async* {
    if (event is StudyEvent) {
      final frameId = event.frameId;
      if (event is CorrectEvent) {
        state.framesToStudy[frameId] = true;
        _onCorrectEvent(frameId);
      } else if (event is WrongEvent) {
        state.framesToStudy[event.frameId] = false;
        _onWrongEvent(event.frameId);
      }

      final nextFrameId = getNextFrameId(frameId);
      // TODO: get character from Repository
    }

    yield state;
  }

  void _onCorrectEvent(String frameId) {
    // TODO: save to stastic
  }

  void _onWrongEvent(String farmeId) {
    // TODO: save to stastic
  }

  @visibleForTesting
  String getNextFrameId(String currentFrameId) {
    assert(_correctFrames > 0);
    final iterator = state.framesToStudy.entries.iterator;

    while (iterator.moveNext()) {
      if (iterator.current.key == currentFrameId) {
        print(
            "___ found key: ${iterator.current.key}: ${iterator.current.value}");
        while (iterator.current.value == true) {
          iterator.moveNext();
          print("___ checking key: ${iterator.current.key} for false");
          if (iterator.current.value == false) {
            return iterator.current.key;
          }
        }
      }
    }

    // we found valid id BEHIND the searched one, just return the first again
    return state.framesToStudy.entries.toList().first.key;
  }

  int get _correctFrames {
    var correctFrames = 0;
    state.framesToStudy.forEach((key, value) {
      if (value) correctFrames++;
    });
    return correctFrames;
  }

  bool get _allCorrect {
    return state.framesToStudy.length == _correctFrames;
  }
}
