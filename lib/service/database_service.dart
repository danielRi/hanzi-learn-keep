import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> initDatabase() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE frames(frameNumber TEXT PRIMARY KEY, seen INTEGER, correct INTEGER, wrong INTEGER, lastseen INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> correct(CharacterStatistic characterStatistic) async {
    final db = await initDatabase();

    db.insert("frames", characterStatistic.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<CharacterStatistic> frame(String frameNumber) async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> frameMaps = await db.query(
      "frames",
      where: "frameNumber = ?",
      whereArgs: [frameNumber],
    );

    final results = List.generate(frameMaps.length, (i) {
      return CharacterStatistic(
        frameNumber: frameMaps[i]['frameNumber'],
        seen: frameMaps[i]['seen'],
        correct: frameMaps[i]['correct'],
        wrong: frameMaps[i]['wrong'],
        lastSeen: DateTime.fromMillisecondsSinceEpoch(frameMaps[i]['lastseen']),
      );
    });

    return results.isEmpty ? null : results[0];
  }

  Future<List<CharacterStatistic>> oldestFrames() async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> frameMaps =
        await db.query("frames", orderBy: "lastseen ASC");

    final results = _rawDataToList(frameMaps);

    return results;
  }

  Future<List<CharacterStatistic>> worstFrames() async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> frameMaps =
        await db.query("frames", orderBy: "wrong DESC");

    final results = _rawDataToList(frameMaps);

    final resultList = List<CharacterStatistic>();
    for (CharacterStatistic statistic in results) {
      if (statistic.successRate < 100) {
        resultList.add(statistic);
      }
    }

    return resultList;
  }

  List<CharacterStatistic> _rawDataToList(
      List<Map<String, dynamic>> frameMaps) {
    return List.generate(frameMaps.length, (i) {
      return CharacterStatistic(
        frameNumber: frameMaps[i]['frameNumber'],
        seen: frameMaps[i]['seen'],
        correct: frameMaps[i]['correct'],
        wrong: frameMaps[i]['wrong'],
        lastSeen: DateTime.fromMillisecondsSinceEpoch(frameMaps[i]['lastseen']),
      );
    });
  }
}
