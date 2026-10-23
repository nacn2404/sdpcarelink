import 'package:flutter/material.dart';

import 'state_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const categories = [
    {'title': 'Apartment', 'icon': Icons.apartment},
    {'title': 'Condominium', 'icon': Icons.business},
    {'title': 'Terrace House', 'icon': Icons.home},
    {'title': 'Detached House', 'icon': Icons.villa},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CareLink")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Property Category",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StateSelectionScreen(
                              category: item['title'] as String,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'] as IconData, size: 60),
                          const SizedBox(height: 10),
                          Text(item['title'] as String),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
