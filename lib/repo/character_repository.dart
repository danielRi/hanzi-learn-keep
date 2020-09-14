import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/service/hanzi_parser_service.dart';

class CharacterRepository {
  static final CharacterRepository _singleton = CharacterRepository._internal();

  factory CharacterRepository() {
    return _singleton;
  }

  CharacterRepository._internal();

  Map<String, CharacterFrame> data;

  Future<Map<String, CharacterFrame>> fetchData() async {
    if (data != null) {
      return data;
    }
    data = await HanziParserService().getDataFromJson();
    return data;
  }

  CharacterFrame getFrame(String frameNumber) {
    return data[frameNumber];
  }
}
