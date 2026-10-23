import 'package:flutter/material.dart';

import '../features/dashboard/presentation/main_dashboard_screen.dart';
import '../shared/services/mock_repositories.dart';

class PropertyListScreen extends StatelessWidget {
  final String category;
  final String state;

  const PropertyListScreen({
    super.key,
    required this.category,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    const properties = demoProperties;

    return Scaffold(
      appBar: AppBar(title: Text("$state Properties")),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.apartment),
              title: Text(properties[index]),
              subtitle: Text('$category · $state'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MainDashboardScreen(propertyName: properties[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
