import '../../log_session/data/session_model.dart';
import '../../auth/data/user_model.dart';

class FeedPost {
  final String id;
  final String userId;
  final String sessionId;
  final DateTime createdAt;
  final AppUser? user;
  final Session? session;
  final bool isLiked;
  final int flexFactor;

  FeedPost({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.createdAt,
    this.user,
    this.session,
    this.isLiked = false,
    this.flexFactor = 50,
  });
}
