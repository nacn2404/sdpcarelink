import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../shared/services/mock_repositories.dart';

class ProjectDiscussionScreen extends StatefulWidget {
  const ProjectDiscussionScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<ProjectDiscussionScreen> createState() =>
      _ProjectDiscussionScreenState();
}

class _ProjectDiscussionScreenState extends State<ProjectDiscussionScreen> {
  final _controller = TextEditingController();
  final _repository = MockProjectRepository();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    _repository.addComment(widget.projectId, _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project discussion')),
      body: AnimatedBuilder(
        animation: _repository.changes,
        builder: (context, _) {
          final comments = _repository.getComments(widget.projectId);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Expanded(
                  child: comments.isEmpty
                      ? const Center(
                          child: Text('Start a constructive discussion.'),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person_outline),
                            ),
                            title: Text(comments[index].$1),
                            subtitle: Text(comments[index].$2),
                          ),
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Add to the conversation',
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Send comment',
                        onPressed: _send,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
