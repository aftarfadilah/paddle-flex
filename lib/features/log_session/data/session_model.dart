import 'package:cloud_firestore/cloud_firestore.dart';

enum SessionResult { win, loss, practice }

class Session {
  final String id;
  final String userId;
  final DateTime date;
  final SessionResult result;
  final String score;
  final int durationMinutes;
  final String? partnerId;
  final List<String> opponentIds;
  final String notes;
  final int flexFactor;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;

  Session({
    required this.id,
    required this.userId,
    required this.date,
    required this.result,
    this.score = '',
    this.durationMinutes = 0,
    this.partnerId,
    this.opponentIds = const [],
    this.notes = '',
    this.flexFactor = 50,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
  });

  factory Session.fromMap(String id, Map<String, dynamic> map) {
    return Session(
      id: id,
      userId: map['userId'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      result: SessionResult.values.firstWhere(
        (e) => e.name == map['result'],
        orElse: () => SessionResult.practice,
      ),
      score: map['score'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      partnerId: map['partnerId'],
      opponentIds: List<String>.from(map['opponentIds'] ?? []),
      notes: map['notes'] ?? '',
      flexFactor: map['flexFactor'] ?? 50,
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'result': result.name,
    'score': score,
    'durationMinutes': durationMinutes,
    'partnerId': partnerId,
    'opponentIds': opponentIds,
    'notes': notes,
    'flexFactor': flexFactor,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  String get resultLabel {
    switch (result) {
      case SessionResult.win: return 'WIN';
      case SessionResult.loss: return 'LOSS';
      case SessionResult.practice: return 'PRACTICE';
    }
  }
}
