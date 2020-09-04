class CharacterFrame {
  final String characterTraditional;
  final String hint;
  final String pinyin;

  /// translation
  final String keyWord;

  final String primitive;

  /// This is unique, works as an id
  final String frameNumber;

  CharacterFrame({
    this.characterTraditional,
    this.hint,
    this.pinyin,
    this.keyWord,
    this.primitive,
    this.frameNumber,
  });
}
