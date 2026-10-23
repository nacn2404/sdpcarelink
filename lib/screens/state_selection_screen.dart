import 'package:flutter/material.dart';

import 'property_list_screen.dart';

class StateSelectionScreen extends StatelessWidget {
  final String category;

  const StateSelectionScreen({super.key, required this.category});

  static const states = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Kuala Lumpur",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Penang",
    "Perak",
    "Selangor",
    "Sarawak",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select State")),
      body: ListView.builder(
        itemCount: states.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(states[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PropertyListScreen(
                    category: category,
                    state: states[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
