import 'dart:convert';

import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:flutter/services.dart' show rootBundle;

class HanziParserService {
  Future<Map<String, CharacterFrame>> getDataFromJson() async {
    print("starting...");
    final resultMap = Map<String, CharacterFrame>();
    final jsonString = await rootBundle.loadString('assets/hanzi.json');

    final Map jsonMap = jsonDecode(jsonString);
    for (String chapterKey in jsonMap.keys) {
      final List chapterList = jsonMap[chapterKey];
      for (Map characterMap in chapterList) {
        final characterFrame = CharacterFrame.fromJson(characterMap);
        resultMap.putIfAbsent(characterFrame.frameNumber, () => characterFrame);
      }
    }
    print("stopping...");
    return resultMap;
  }
}
