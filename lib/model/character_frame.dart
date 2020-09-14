class CharacterFrame {
  final String characterTraditional;
  final String hint;
  final String pinyin;

  /// translation
  final String keyWord;

  final String primitive;

  /// This is unique, works as an id
  final String frameNumber;

  factory CharacterFrame.fromJson(Map<String, dynamic> map) {
    final characterTraditional = map["character"];
    final hint = map["hint"];
    final keyWord = map["keyword"];
    final primitive = map["primitive"];
    final frameNumber = map["frame"];

    return CharacterFrame(
        characterTraditional, hint, null, keyWord, primitive, frameNumber);
  }

  CharacterFrame(
    this.characterTraditional,
    this.hint,
    this.pinyin,
    this.keyWord,
    this.primitive,
    this.frameNumber,
  );
}
