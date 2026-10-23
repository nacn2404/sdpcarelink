import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/themes/app_theme.dart';
import '../models/issue_model.dart';
import '../widgets/issue_status_badge.dart';

class IssueDetailScreen extends StatelessWidget {
  const IssueDetailScreen({super.key, required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue tracking')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issue.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IssueStatusBadge(status: issue.status),
                      Chip(
                        label: Text('${issue.severity} severity'),
                        backgroundColor: const Color(0xFFFFF4E5),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(issue.description),
                  const SizedBox(height: AppSpacing.md),
                  _MetadataRow(icon: Icons.place_outlined, text: issue.location),
                  _MetadataRow(icon: Icons.person_outline, text: 'Reported by ${issue.reportedBy}'),
                  _MetadataRow(
                    icon: Icons.calendar_today_outlined,
                    text: 'Reported ${issue.createdAt.day}/${issue.createdAt.month}/${issue.createdAt.year}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Progress timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: issue.progressTimeline.asMap().entries.map((item) {
                  return _TimelineEntry(
                    entry: item.value,
                    isLast: item.key == issue.progressTimeline.length - 1,
                  );
                }).toList(),
              ),
            ),
          ),
          if (issue.managementResponse.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_outlined, color: AppTheme.success),
                title: const Text('Resolution details'),
                subtitle: Text(issue.managementResponse),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.entry, required this.isLast});

  final IssueTimelineEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                color: const Color(0xFFDDE6E1),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.status, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year} · ${entry.note}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
