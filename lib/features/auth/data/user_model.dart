import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String displayName;
  final String username;
  final String? avatarUrl;
  final String clubName;
  final String bio;
  final int sessionCount;
  final int winCount;
  final int lossCount;
  final int currentStreak;
  final int bestStreak;
  final int followerCount;
  final int followingCount;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.displayName,
    required this.username,
    this.avatarUrl,
    this.clubName = '',
    this.bio = '',
    this.sessionCount = 0,
    this.winCount = 0,
    this.lossCount = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    required this.createdAt,
  });

  double get winRate {
    final total = winCount + lossCount;
    if (total == 0) return 0;
    return (winCount / total) * 100;
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      displayName: map['displayName'] ?? 'Unknown',
      username: map['username'] ?? id,
      avatarUrl: map['avatarUrl'],
      clubName: map['clubName'] ?? '',
      bio: map['bio'] ?? '',
      sessionCount: map['sessionCount'] ?? 0,
      winCount: map['winCount'] ?? 0,
      lossCount: map['lossCount'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      bestStreak: map['bestStreak'] ?? 0,
      followerCount: map['followerCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'displayName': displayName,
    'username': username,
    'avatarUrl': avatarUrl,
    'clubName': clubName,
    'bio': bio,
    'sessionCount': sessionCount,
    'winCount': winCount,
    'lossCount': lossCount,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'followerCount': followerCount,
    'followingCount': followingCount,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
