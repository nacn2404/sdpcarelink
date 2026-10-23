import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../shared/services/mock_repositories.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _repository = MockPostRepository();
  String _tag = 'Community';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _createPost() {
    if (!_formKey.currentState!.validate()) return;
    _repository.createPost(
      _titleController.text,
      _contentController.text,
      tags: [_tag],
      propertyName: widget.propertyName,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a post')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Post title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Add a title'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'What is happening in your community?',
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Add some details'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _tag,
                decoration: const InputDecoration(labelText: 'Topic'),
                items:
                    const [
                          'Community',
                          'Parking',
                          'Security',
                          'Facilities',
                          'Maintenance',
                          'Events',
                        ]
                        .map(
                          (tag) =>
                              DropdownMenuItem(value: tag, child: Text(tag)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _tag = value);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _createPost,
                icon: const Icon(Icons.send_outlined),
                label: const Text('Publish post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
