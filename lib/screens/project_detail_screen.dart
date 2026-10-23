import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../models/project_model.dart';
import '../widgets/project_voting_widget.dart';
import 'project_discussion_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Project overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(project.description),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(title: 'Expected benefits', items: project.benefits),
          _InfoCard(title: 'Potential risks', items: project.risks),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timeline_outlined),
              title: const Text('Estimated timeline'),
              subtitle: Text(project.estimatedTimeline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ProjectVotingWidget(projectId: project.id),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProjectDiscussionScreen(projectId: project.id),
              ),
            ),
            icon: const Icon(Icons.forum_outlined),
            label: const Text('Join project discussion'),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(top: AppSpacing.md),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 7),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
