import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/themes/app_theme.dart';
import '../shared/services/mock_repositories.dart';

class ProjectVotingWidget extends StatelessWidget {
  const ProjectVotingWidget({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final repository = MockProjectRepository();
    return AnimatedBuilder(
      animation: repository.changes,
      builder: (context, _) {
        final project = repository.getById(projectId);
        if (project == null) return const Text('Project not found.');
        final total = project.totalVotes;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community vote',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('$total residents have shared their view'),
            const SizedBox(height: AppSpacing.md),
            _VoteResult(
              label: 'Support',
              count: project.supportCount,
              total: total,
              color: AppTheme.secondary,
            ),
            _VoteResult(
              label: 'Oppose',
              count: project.opposeCount,
              total: total,
              color: AppTheme.error,
            ),
            _VoteResult(
              label: 'More information',
              count: project.moreInfoCount,
              total: total,
              color: AppTheme.accent,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _VoteButton(
                  label: 'Support',
                  icon: Icons.thumb_up_alt_outlined,
                  selected: project.myVote == 'Support',
                  onPressed: () => repository.vote(projectId, 'Support'),
                ),
                _VoteButton(
                  label: 'Oppose',
                  icon: Icons.thumb_down_alt_outlined,
                  selected: project.myVote == 'Oppose',
                  onPressed: () => repository.vote(projectId, 'Oppose'),
                ),
                _VoteButton(
                  label: 'More info',
                  icon: Icons.help_outline,
                  selected: project.myVote == 'Request More Information',
                  onPressed: () =>
                      repository.vote(projectId, 'Request More Information'),
                ),
              ],
            ),
            if (project.myVote != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your response: ${project.myVote}. Tap again to remove it.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _VoteResult extends StatelessWidget {
  const _VoteResult({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text('$count · ${(fraction * 100).round()}%'),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8,
              color: color,
              backgroundColor: const Color(0xFFE9EDF3),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => selected
      ? FilledButton.tonalIcon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        )
      : OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        );
}
