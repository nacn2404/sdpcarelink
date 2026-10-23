import 'package:flutter/material.dart';

import '../../community/presentation/home_feed_screen.dart';
import '../../events/presentation/events_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../screens/issue_list_screen.dart';
import '../../../screens/project_list_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key, required this.propertyName});

  final String propertyName;

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;
  late String _propertyName = widget.propertyName;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeedScreen(
        propertyName: _propertyName,
        onNavigate: _selectTab,
        onPropertyChanged: (property) => setState(() => _propertyName = property),
      ),
      IssueListScreen(
        key: const PageStorageKey('issues'),
        propertyName: _propertyName,
      ),
      ProjectListScreen(
        key: const PageStorageKey('projects'),
        propertyName: _propertyName,
      ),
      EventsScreen(
        key: const PageStorageKey('events'),
        propertyName: _propertyName,
      ),
      ProfileScreen(
        key: const PageStorageKey('profile'),
        propertyName: _propertyName,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_outlined),
            selectedIcon: Icon(Icons.report),
            label: 'Issues',
          ),
          NavigationDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }
}
