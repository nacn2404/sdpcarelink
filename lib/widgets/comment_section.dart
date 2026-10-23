import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../shared/services/mock_repositories.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.postId});

  final String postId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _controller = TextEditingController();
  final _repository = MockPostRepository();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addComment() {
    _repository.addComment(widget.postId, _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repository.changes,
      builder: (context, _) {
        final post = _repository.getById(widget.postId);
        if (post == null) return const Center(child: Text('Post not found.'));
        return Column(
          children: [
            Expanded(
              child: post.comments.isEmpty
                  ? const Center(child: Text('Start the conversation.'))
                  : ListView.separated(
                      itemCount: post.comments.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) => ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person_outline),
                        ),
                        title: const Text('Green Heights Resident'),
                        subtitle: Text(post.comments[index]),
                      ),
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                        ),
                        onSubmitted: (_) => _addComment(),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Post comment',
                      onPressed: _addComment,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
