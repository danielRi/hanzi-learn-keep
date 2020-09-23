import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/service/database_service.dart';

class StatisticRepository {
  static final StatisticRepository _singleton = StatisticRepository._internal();

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

  Future<void> wrong(String frameKey) async {
    print("wrong called");
  }
}
