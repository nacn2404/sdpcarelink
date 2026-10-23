import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/themes/app_theme.dart';
import '../models/issue_model.dart';
import '../shared/services/mock_repositories.dart';
import '../widgets/issue_status_badge.dart';
import 'issue_detail_screen.dart';
import 'report_issue_screen.dart';

class IssueListScreen extends StatelessWidget {
  IssueListScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;
  final MockIssueRepository _repository = MockIssueRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resident issue center')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ReportIssueScreen(propertyName: propertyName),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Report issue'),
      ),
      body: AnimatedBuilder(
        animation: _repository.changes,
        builder: (context, _) {
          final issues = _repository.getIssues(propertyName: propertyName);
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              96,
            ),
            children: [
              _IssueSummary(issues: issues),
              const SizedBox(height: AppSpacing.md),
              ...issues.map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _IssueCard(
                    issue: issue,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => IssueDetailScreen(issue: issue),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IssueSummary extends StatelessWidget {
  const _IssueSummary({required this.issues});

  final List<Issue> issues;

  @override
  Widget build(BuildContext context) {
    final open = issues.where((issue) => issue.status != 'Resolved').length;
    final resolved = issues.length - open;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                value: '$open',
                label: 'Open reports',
                color: AppTheme.primary,
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                value: '$resolved',
                label: 'Resolved',
                color: AppTheme.success,
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                value: '${issues.length}',
                label: 'Total',
                color: const Color(0xFF596579),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(color: color, fontSize: 23, fontWeight: FontWeight.w700)),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue, required this.onTap});

  final Issue issue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final severityColor = switch (issue.severity) {
      'Critical' => const Color(0xFFD32F2F),
      'High' => const Color(0xFFEF6C00),
      'Medium' => const Color(0xFFFFB800),
      _ => const Color(0xFF2E7D32),
    };
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      issue.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      issue.severity,
                      style: TextStyle(color: severityColor, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(issue.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${issue.location} · ${issue.reportedBy}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IssueStatusBadge(status: issue.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _IssueProgress(status: issue.status),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Reported ${issue.createdAt.day}/${issue.createdAt.month}/${issue.createdAt.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IssueProgress extends StatelessWidget {
  const _IssueProgress({required this.status});

  final String status;
  static const stages = [
    'Submitted',
    'Acknowledged',
    'Assigned',
    'In Progress',
    'Resolved',
  ];

  @override
  Widget build(BuildContext context) {
    final index = stages.indexOf(status).clamp(0, stages.length - 1);
    return Row(
      children: List.generate(stages.length * 2 - 1, (position) {
        if (position.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: position ~/ 2 < index
                  ? AppTheme.success
                  : const Color(0xFFE2E7EF),
            ),
          );
        }
        final step = position ~/ 2;
        final complete = step <= index;
        return Tooltip(
          message: stages[step],
          child: Icon(
            complete ? Icons.check_circle : Icons.circle_outlined,
            size: 17,
            color: complete ? AppTheme.success : Colors.black26,
          ),
        );
      }),
    );
  }
}
