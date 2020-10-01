import 'dart:convert';

class CharacterStatistic {
  final String frameNumber;
  int seen;
  int correct;
  int wrong;
  DateTime lastSeen;

  CharacterStatistic({
    this.frameNumber,
    this.seen,
    this.correct,
    this.wrong,
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'frameNumber': frameNumber,
      'seen': seen,
      'correct': correct,
      'wrong': wrong,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
    };
  }

  factory CharacterStatistic.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CharacterStatistic(
      frameNumber: map['frameNumber'],
      seen: map['seen'],
      correct: map['correct'],
      wrong: map['wrong'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterStatistic.fromJson(String source) =>
      CharacterStatistic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CharacterStatistic(frameNumber: $frameNumber, seen: $seen, correct: $correct, wrong: $wrong, lastSeen: $lastSeen)';
  }

  int get successRate {
    return ((correct / seen) * 100).round();
  }

  void correctEvent() {
    seen = seen + 1;
    correct = correct + 1;
    lastSeen = DateTime.now();
  }

  void wrongEvent() {
    seen = seen + 1;
    wrong = wrong + 1;
    lastSeen = DateTime.now();
  }
}
