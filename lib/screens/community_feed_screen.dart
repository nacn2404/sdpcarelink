import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../shared/services/mock_repositories.dart';
import '../widgets/post_card.dart';
import 'create_post_screen.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;

  @override
  Widget build(BuildContext context) {
    final repository = MockPostRepository();
    return Scaffold(
      appBar: AppBar(title: Text('$propertyName community')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreatePostScreen(propertyName: propertyName),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: AnimatedBuilder(
        animation: repository.changes,
        builder: (context, _) {
          final posts = repository.getPosts(propertyName: propertyName);
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: posts.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => PostCard(post: posts[index]),
          );
        },
      ),
    );
  }
}
