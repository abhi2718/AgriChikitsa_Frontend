class BotMessage1 {
  final String id;
  final String questionHi;
  final String questionEn;
  final List<Option> options;

  BotMessage1({
    required this.id,
    required this.questionHi,
    required this.questionEn,
    required this.options,
  });

  factory BotMessage1.fromJson(Map<String, dynamic> json) {
    return BotMessage1(
      id: json['id'],
      questionHi: json['question_hi'],
      questionEn: json['question_en'],
      options: json['options'] != null
          ? List<Option>.from(json['options'].map((x) => Option.fromJson(x)))
          : [],
    );
  }
}

class Option {
  final String optionHi;
  final String optionEn;
  final String qId;
  final String optId;

  Option({
    required this.optionHi,
    required this.optionEn,
    required this.qId,
    required this.optId,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionHi: json['option_hi'],
      optionEn: json['option_en'],
      qId: json['q_id'],
      optId: json['opt_id'],
    );
  }
}
