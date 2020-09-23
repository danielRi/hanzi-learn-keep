import 'dart:math';

import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/service/database_service.dart';

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
    var characterStastic = await DatabaseService().frame(frameNumber);
    if (characterStastic != null) {
      characterStastic.correctEvent();
    } else {
      characterStastic = CharacterStatistic(
        frameNumber: frameNumber,
        seen: 1,
        correct: 1,
        wrong: 0,
        lastSeen: DateTime.now(),
      );
    }
    await DatabaseService().correct(characterStastic);
  }

  Future<void> wrong(String frameNumber) async {
    print("wrong called");
    var characterStastic = await DatabaseService().frame(frameNumber);
    if (characterStastic != null) {
      characterStastic.wrongEvent();
    } else {
      characterStastic = CharacterStatistic(
        frameNumber: frameNumber,
        seen: 0,
        correct: 1,
        wrong: 1,
        lastSeen: DateTime.now(),
      );
    }
    await DatabaseService().correct(characterStastic);
  }

  /// Creates list of frames based on stastic data
  ///
  /// 1. New frames, never studied
  /// 2. Oldest frames, havent been seen in a while
  /// 3. Worst frames, with most wrong tries
  /// 4. Random frames
  Future<List<String>> createSuitableStudyList(int amountOfCharacters) async {
    final data = await CharacterRepository().fetchData();
    final resultList = List<String>();
    final random = Random();
    final oldestFrames = await DatabaseService().oldestFrames();
    final worstFrames = await DatabaseService().worstFrames();
    final lastindex = data.keys.toList().length - 1;
    if (oldestFrames.length + worstFrames.length < amountOfCharacters) {
      // not enogh data yet, just put random
      while (resultList.length < amountOfCharacters) {
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
          resultList.add(randomFrameId);
        }
      }
      return resultList;
    }
    print("Already have data, check new frames first");
    final newFrames = _newFrames(oldestFrames, data);
    print("newFrames: ${newFrames.length}");
    while (resultList.length < min(amountOfCharacters, newFrames.length)) {
      print("resultList.length: ${resultList.length}");
      final frame = _getRandomFrameFromList(newFrames, resultList);
      resultList.add(frame);
    }
    if (resultList.length == amountOfCharacters) {
      print("Meaningful List with only new Frames");
      return resultList;
    }
    print("Not enough new frames");
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

  String _getRandomFrameFromList(List<String> list, List<String> targetList) {
    final random = Random();
    final lastindex = list.length;
    while (true) {
      print(
          "list.length: ${list.length} --- targetList.length: ${targetList.length}");

      final randomIndex = random.nextInt(lastindex);
      String randomFrameId = list[randomIndex];
      bool frameAlreadyExists = false;

      targetList.forEach((element) {
        if (element == randomFrameId) {
          print("frame Exists: $randomFrameId");
          frameAlreadyExists = true;
          return;
        }
      });
      if (targetList.length == 44) {
        print("stop");
      }
      //print("getting random: $randomFrameId");
      if (frameAlreadyExists == false) {
        return randomFrameId;
      }
    }
  }
}
