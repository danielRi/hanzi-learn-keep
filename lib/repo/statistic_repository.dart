import 'dart:math';

import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/service/database_service.dart';
import 'package:hanzi_learn_keep/bloc/study_bloc.dart';

class StatisticRepository {
  static final StatisticRepository _singleton = StatisticRepository._internal();

  List<String> recentlyStudied = List();

  factory StatisticRepository() {
    return _singleton;
  }

  StatisticRepository._internal();

  Future<void> initDatabase() async {
    print("initDatabase called");
    await DatabaseService().initDatabase();
  }

  Future<void> correct(String frameNumber) async {
    print("correct called");
    recentlyStudied.add(frameNumber);
    var characterStatistic = await DatabaseService().frame(frameNumber);
    if (characterStatistic != null) {
      characterStatistic.correctEvent();
    } else {
      characterStatistic = CharacterStatistic(
        frameNumber: frameNumber,
        seen: 1,
        correct: 1,
        wrong: 0,
        lastSeen: DateTime.now(),
      );
    }
    await DatabaseService().correct(characterStatistic);
  }

  Future<void> wrong(String frameNumber) async {
    print("wrong called");
    var characterStatistic = await DatabaseService().frame(frameNumber);
    if (characterStatistic != null) {
      characterStatistic.wrongEvent();
    } else {
      characterStatistic = CharacterStatistic(
        frameNumber: frameNumber,
        seen: 1,
        correct: 0,
        wrong: 1,
        lastSeen: DateTime.now(),
      );
    }
    await DatabaseService().correct(characterStatistic);
  }

  Future<CharacterStatistic> worstFrame() async {
    final frames = await DatabaseService().worstFrames();
    return frames.isNotEmpty ? frames[0] : null;
  }

  Future<int> framesStudied() async {
    final frames = await DatabaseService().oldestFrames();
    var framesStudied = 0;
    for (CharacterStatistic frameStatistic in frames) {
      framesStudied += frameStatistic.seen;
    }
    return framesStudied;
  }

  Future<int> globalSuccessRate() async {
    final studiedFrames = await framesStudied();
    final frames = await DatabaseService().oldestFrames();
    var correctFrames = 0;
    for (CharacterStatistic frameStatistic in frames) {
      correctFrames += frameStatistic.correct;
    }
    if (studiedFrames != 0) {
      final successRate = ((correctFrames / studiedFrames) * 100).round();
      return successRate;
    }
    return 0;
  }

  /// Creates list of frames based on statistic data
  ///
  /// 1. New frames, never studied
  /// 2. Worst frames, with most wrong tries
  /// 3. Oldest frames, havent been seen in a while
  /// 4. Random frames
  Future<List<String>> createSuitableStudyList(
      int amountOfCharacters, StudyType type) async {
    final data = await CharacterRepository().fetchData();
    final resultList = List<String>();

    var userRequestedFrames;
    if (type == StudyType.least) {
      userRequestedFrames = await DatabaseService().leastFrames();
    } else {
      userRequestedFrames = await DatabaseService().oldestFrames();
    }

    final worstFrames = await DatabaseService().worstFrames();

    if (userRequestedFrames.length + worstFrames.length < amountOfCharacters) {
      // not enogh data yet, just put random
      print("not enough data, just put random");
      while (resultList.length < amountOfCharacters) {
        final frame = _getRandomFrameFromDataMap(resultList, data);
        resultList.add(frame);
      }
      print("Meaningful List list with new data");
      return resultList..shuffle();
    }
    print("Already have data, check new frames first");
    final newFrames = _newFrames(userRequestedFrames, data);
    var amountOfNewFrames = 0;
    while (resultList.length < min(amountOfCharacters, newFrames.length)) {
      final frame = _getRandomFrameFromList(resultList, stringList: newFrames);
      amountOfNewFrames++;
      resultList.add(frame);
    }
    if (resultList.length == amountOfCharacters) {
      print("Meaningful List with only new Frames");
      return resultList..shuffle();
    }
    print("Not enough new frames, only ${amountOfNewFrames.toString()}");

    // add maximum 4 worst words
    var amountOfWorstFrames = 0;
    while (amountOfWorstFrames < min(4, worstFrames.length)) {
      final frame = _getRandomFrameFromList(resultList,
          characterStatisticList: worstFrames);
      amountOfWorstFrames++;
      resultList.add(frame);
    }
    if (resultList.length == amountOfCharacters) {
      print(
          "Meaningful List with ${amountOfNewFrames.toString()} new Frames and ${amountOfWorstFrames.toString()} worst frames");
      return resultList..shuffle();
    }
    print(
        "Not enough worst frames, added ${amountOfWorstFrames.toString()} worst frames, in sum now ${resultList.length.toString()}");

    var amountOfOldestFrames = 0;
    while (resultList.length <
        min(amountOfCharacters, userRequestedFrames.length)) {
      final frame = userRequestedFrames[amountOfOldestFrames];
      amountOfOldestFrames++;
      resultList.add(frame.frameNumber);
    }
    if (resultList.length == amountOfCharacters) {
      print(
          "Meaningful List with ${amountOfNewFrames.toString()} new Frames, ${amountOfWorstFrames.toString()} worst frames and ${amountOfOldestFrames.toString()} oldest frames");
      return resultList..shuffle();
    }
    print(
        "Not enough oldest frames, added ${amountOfOldestFrames.toString()} old frames, in sum now ${resultList.length.toString()}");

    var amountOfRandomFrames = 0;
    while (resultList.length < amountOfCharacters) {
      final frame = _getRandomFrameFromDataMap(resultList, data);
      amountOfRandomFrames++;
      resultList.add(frame);
    }
    print(
        "Meaningful List with ${amountOfNewFrames.toString()} new Frames, ${amountOfOldestFrames.toString()} oldest frames, ${amountOfWorstFrames.toString()} worst frames and ${amountOfRandomFrames.toString()} random frames");
    return resultList..shuffle();
  }

  List<String> _newFrames(
      List<CharacterStatistic> oldestFrames, Map<String, CharacterFrame> data) {
    List<String> newFrames = List();
    for (CharacterFrame frame in data.values) {
      bool isNew = true;
      oldestFrames.forEach((element) {
        if (element.frameNumber == frame.frameNumber) {
          isNew = false;
          return;
        }
      });
      if (isNew) {
        newFrames.add(frame.frameNumber);
      }
    }
    return newFrames;
  }

  String _getRandomFrameFromList(List<String> targetList,
      {List<String> stringList,
      List<CharacterStatistic> characterStatisticList}) {
    if (stringList != null) {
      assert(characterStatisticList == null);
    } else if (characterStatisticList != null) {
      assert(stringList == null);
    }
    final random = Random();
    final lastindex =
        stringList != null ? stringList.length : characterStatisticList.length;
    while (true) {
      final randomIndex = random.nextInt(lastindex);
      String randomFrameId = stringList != null
          ? stringList[randomIndex]
          : characterStatisticList[randomIndex].frameNumber;
      bool frameAlreadyExists = false;

      targetList.forEach((element) {
        if (element == randomFrameId) {
          frameAlreadyExists = true;
          return;
        }
      });
      if (frameAlreadyExists == false) {
        return randomFrameId;
      }
    }
  }

  String _getRandomFrameFromDataMap(
      List<String> resultList, Map<String, CharacterFrame> data) {
    final random = Random();
    final lastindex = data.keys.toList().length;
    while (true) {
      final randomIndex = random.nextInt(lastindex);
      String randomFrameId = data.keys.toList()[randomIndex];
      bool frameAlreadyExists = false;
      resultList.forEach((element) {
        if (element == randomFrameId) {
          frameAlreadyExists = true;
          return;
        }
      });
      if (frameAlreadyExists == false) {
        return randomFrameId;
      }
    }
  }
}
