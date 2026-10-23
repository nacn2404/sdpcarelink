class PostModel {
  PostModel({
    required this.id,
    required this.propertyId,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.body,
    required this.createdAt,
    this.propertyName = 'Green Heights Residence',
    this.imageUrl,
    this.tags = const [],
    this.likes = 0,
    this.comments = const [],
  }) : reactionCounts = {'Like': likes};

  final String id;
  final String propertyId;
  final String authorId;
  final String authorName;
  final String propertyName;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? imageUrl;
  final List<String> tags;
  int likes;
  final List<String> comments;
  String? myReaction;
  final Map<String, int> reactionCounts;

  int get commentCount => comments.length;

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
