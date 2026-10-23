import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/themes/app_theme.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart';
import '../shared/services/mock_repositories.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  static const _reactions = <(String, String, IconData)>[
    ('Like', '👍', Icons.thumb_up_alt_outlined),
    ('Love', '❤️', Icons.favorite_border),
    ('Support', '✅', Icons.check_circle_outline),
    ('Concern', '⚠️', Icons.warning_amber_outlined),
    ('Informative', '💡', Icons.lightbulb_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final repository = MockPostRepository();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _avatarColor(post.authorName),
                  child: Text(
                    _initials(post.authorName),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${post.propertyName} · ${post.timeAgo}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'More options',
                  onPressed: () => _showMore(context),
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(post.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(post.body),
            if (post.imageUrl != null) ...[
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 190,
                  width: double.infinity,
                  color: const Color(0xFFE6F1FF),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                children: post.tags
                    .map(
                      (tag) => Text(
                        '#$tag',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Text('👍 ❤️ ✅ ⚠️ 💡', style: TextStyle(fontSize: 15)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${post.reactionCounts.values.fold<int>(0, (sum, count) => sum + count)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${post.commentCount} comments',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: PopupMenuButton<String>(
                    tooltip: 'React to post',
                    onSelected: (reaction) =>
                        repository.react(post.id, reaction),
                    itemBuilder: (context) => _reactions
                        .map(
                          (item) => PopupMenuItem(
                            value: item.$1,
                            child: Text('${item.$2}  ${item.$1}'),
                          ),
                        )
                        .toList(),
                    child: _ActionButton(
                      icon: post.myReaction == 'Love'
                          ? Icons.favorite
                          : Icons.thumb_up_alt_outlined,
                      label: post.myReaction ?? 'React',
                      selected: post.myReaction != null,
                    ),
                  ),
                ),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.mode_comment_outlined,
                    label: 'Comment',
                    onTap: () => _openDetails(context),
                  ),
                ),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.ios_share_outlined,
                    label: 'Share',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post link copied for sharing.'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)));
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.flag_outlined),
          title: const Text('Report post'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thanks. The post was flagged for review.'),
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'
        : name.substring(0, 1).toUpperCase();
  }

  Color _avatarColor(String name) =>
      Colors.primaries[name.length % Colors.primaries.length].shade100;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppTheme.primary : Colors.black54,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? AppTheme.primary : Colors.black54,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
