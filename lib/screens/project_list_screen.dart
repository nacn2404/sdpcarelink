import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/themes/app_theme.dart';
import '../models/project_model.dart';
import '../shared/services/mock_repositories.dart';
import 'project_detail_screen.dart';

class ProjectListScreen extends StatelessWidget {
  ProjectListScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;
  final MockProjectRepository _repository = MockProjectRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community projects')),
      body: AnimatedBuilder(
        animation: _repository.changes,
        builder: (context, _) {
          final projects = _repository.getProjects(propertyName: propertyName);
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: projects.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _ProjectCard(
              project: projects[index],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProjectDetailScreen(project: projects[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = project.totalVotes;
    final support = total == 0 ? 0.0 : project.supportCount / total;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE6F7F0),
                    child: Icon(Icons.apartment_outlined, color: AppTheme.secondary),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(project.description),
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(
                value: support,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.secondary,
                backgroundColor: const Color(0xFFE9EDF3),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text('${project.supportCount} support'),
                  const Spacer(),
                  Text('$total responses'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Timeline · ${project.estimatedTimeline}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
