import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';

void main() {
  group('StudyBloc', () {
    StudyBloc studyBloc;

    setUp(() {
      // studyBloc = StudyBloc(StudyState(
      //   null,
      //   LinkedHashMap.from({
      //     "1": false,
      //     "2": false,
      //     "3": false,
      //     "4": false,
      //     "5": false,
      //   }),
      // ));
      // TODO: set up new unit tests
    });

    test('getNextFrameId', () async {
      expect(() {
        studyBloc.getNextFrameId("1");
      }, throwsAssertionError);
      studyBloc.add(CorrectEvent("1"));
      await Future.delayed(Duration.zero);
      expect(studyBloc.getNextFrameId("1"), "2");
      studyBloc.add(CorrectEvent("2"));
      await Future.delayed(Duration.zero);
      expect(studyBloc.getNextFrameId("1"), "3");
      studyBloc.add(CorrectEvent("3"));
      await Future.delayed(Duration.zero);
      expect(studyBloc.getNextFrameId("1"), "4");
      studyBloc.add(CorrectEvent("4"));
      await Future.delayed(Duration.zero);
      expect(studyBloc.getNextFrameId("1"), "5");
    });
  });
}
