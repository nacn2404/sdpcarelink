import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../shared/services/mock_repositories.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _repository = MockIssueRepository();
  String _category = 'Maintenance';
  String _severity = 'Medium';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _repository.reportIssue(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category,
      location: _locationController.text,
      severity: _severity,
      propertyName: widget.propertyName,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Issue submitted to the demo management team.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an issue')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('Tell us what needs attention', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Issue title'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Describe the issue'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Add a location' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                'Maintenance',
                'Security',
                'Facilities',
                'Parking',
                'Cleaning',
                'Other',
              ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _severity,
              decoration: const InputDecoration(labelText: 'Severity'),
              items: const ['Critical', 'High', 'Medium', 'Low']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _severity = value);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Submit report'),
            ),
          ],
        ),
      ),
    );
  }
}
