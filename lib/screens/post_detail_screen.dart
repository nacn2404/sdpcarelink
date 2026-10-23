import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../models/post_model.dart';
import '../widgets/comment_section.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussion')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('${post.authorName} · ${post.propertyName} · ${post.timeAgo}'),
            const SizedBox(height: AppSpacing.md),
            Text(post.body),
            const Divider(height: AppSpacing.lg),
            Expanded(child: CommentSection(postId: post.id)),
          ],
        ),
      ),
    );
  }
}
