import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/services/mock_repositories.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;
  final MockProfileRepository _repository = MockProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resident profile')),
      body: AnimatedBuilder(
        animation: _repository.changes,
        builder: (context, _) {
          final resident = _repository.resident;
          final activities = _repository.recentActivities;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundColor: Color(0xFFE6F1FF),
                        child: Icon(Icons.person, color: AppTheme.primary, size: 40),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(resident.name, style: Theme.of(context).textTheme.headlineSmall),
                      Text(propertyName),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Resident since ${resident.residentSince}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: AppTheme.accent, size: 34),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${resident.participationPoints} points', style: Theme.of(context).textTheme.titleLarge),
                          const Text('Thanks for making your community better'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Community badges', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: resident.badges.map((badge) => _Badge(label: badge)).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Your activity', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Column(
                  children: [
                    _ActivityCount(
                      icon: Icons.report_outlined,
                      label: 'Issues reported',
                      count: _repository.issuesReported,
                    ),
                    const Divider(height: 1, indent: 56),
                    _ActivityCount(
                      icon: Icons.how_to_vote_outlined,
                      label: 'Projects voted',
                      count: _repository.projectsVoted,
                    ),
                    const Divider(height: 1, indent: 56),
                    _ActivityCount(
                      icon: Icons.event_available_outlined,
                      label: 'Events joined',
                      count: _repository.eventsJoined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: activities.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Text('Your community activity will appear here.'),
                      )
                    : Column(
                        children: activities
                            .map(
                              (activity) => ListTile(
                                leading: const Icon(Icons.check_circle_outline, color: AppTheme.secondary),
                                title: Text(activity),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: const Icon(Icons.workspace_premium_outlined, size: 18),
    label: Text(label),
    backgroundColor: const Color(0xFFFFF5D6),
  );
}

class _ActivityCount extends StatelessWidget {
  const _ActivityCount({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    trailing: Text('$count', style: Theme.of(context).textTheme.titleMedium),
  );
}
