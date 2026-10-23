import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String propertyName;

  const DashboardScreen({super.key, required this.propertyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(propertyName)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text("Community Feed"),
            subtitle: const Text("Member 2 Module"),
            onTap: () {
              // CommunityFeedScreen()
            },
          ),

          ListTile(
            leading: const Icon(Icons.report),
            title: const Text("Issue Reporting"),
            subtitle: const Text("Member 3 Module"),
            onTap: () {
              // IssueScreen()
            },
          ),

          ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: const Text("Proposed Projects"),
            subtitle: const Text("Member 4 Module"),
            onTap: () {
              // ProjectListScreen()
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            subtitle: const Text("Member 5 Module"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
