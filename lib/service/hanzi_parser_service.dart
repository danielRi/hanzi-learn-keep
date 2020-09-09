import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:flutter/services.dart' show rootBundle;

class HanziParserService {
  Future<Map<String, CharacterFrame>> getDataFromJson() async {
    print("starting...");
    final jsonString = await rootBundle.loadString('assets/hanzi.json');

    print("jsonString: $jsonString");
  }
}
