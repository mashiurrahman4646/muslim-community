class AskQuestionModel {
  final String id;
  final String userId;
  final String userRole;
  final String question;
  final String status;
  final List<AnswerModel> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  AskQuestionModel({
    required this.id,
    required this.userId,
    required this.userRole,
    required this.question,
    required this.status,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AskQuestionModel.fromJson(Map<String, dynamic> json) {
    return AskQuestionModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      userRole: json['userRole'] ?? '',
      question: json['question'] ?? '',
      status: json['status'] ?? 'pending',
      answers: (json['answers'] as List?)?.map((e) {
            if (e is String) {
              return AnswerModel(
                id: '',
                answer: e,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
            } else if (e is Map) {
              return AnswerModel.fromJson(Map<String, dynamic>.from(e));
            } else {
              return AnswerModel(
                id: '',
                answer: e?.toString() ?? '',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
            }
          }).toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt']) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt']) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}

class AnswerModel {
  final String id;
  final String? questionId;
  final String answer;
  final String? answeredBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnswerModel({
    required this.id,
    this.questionId,
    required this.answer,
    this.answeredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? json['_id'] ?? '',
      questionId: json['questionId'],
      answer: json['answer'] ?? json['ans'] ?? json['content'] ?? json['text'] ?? json['reply'] ?? '',
      answeredBy: json['answeredBy'],
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt']) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt']) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
