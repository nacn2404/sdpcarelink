import 'package:flutter/material.dart';

class IssueStatusBadge extends StatelessWidget {
  final String status;

  const IssueStatusBadge({super.key, required this.status});

  Color getStatusColor() {
    switch (status) {
      case 'Submitted':
        return const Color(0xFFEF6C00);

      case 'Acknowledged':
      case 'Assigned':
        return const Color(0xFF0066CC);

      case 'In Progress':
        return const Color(0xFF7B61A8);

      case 'Resolved':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: getStatusColor(),
      label: Text(status, style: const TextStyle(color: Colors.white)),
    );
  }
}
