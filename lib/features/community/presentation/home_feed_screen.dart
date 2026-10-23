import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/themes/app_theme.dart';
import '../../../models/issue_model.dart';
import '../../../models/project_model.dart';
import '../../../screens/create_post_screen.dart';
import '../../../screens/issue_detail_screen.dart';
import '../../../screens/project_detail_screen.dart';
import '../../../shared/services/mock_repositories.dart';
import '../../../widgets/issue_status_badge.dart';
import '../../../widgets/post_card.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({
    super.key,
    required this.propertyName,
    required this.onNavigate,
    required this.onPropertyChanged,
  });

  final String propertyName;
  final ValueChanged<int> onNavigate;
  final ValueChanged<String> onPropertyChanged;

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _posts = MockPostRepository();
  final _issues = MockIssueRepository();
  final _projects = MockProjectRepository();
  final _events = MockEventRepository();
  String? _selectedTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareLink'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You’re all caught up.')),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreatePostScreen()),
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Post'),
      ),
      body: AnimatedBuilder(
        animation: _posts.changes,
        builder: (context, _) {
          final posts = _posts.getPosts(propertyName: widget.propertyName);
          final visiblePosts = _selectedTag == null
              ? posts
              : posts.where((post) => post.tags.contains(_selectedTag)).toList();
          final issues = _issues.getIssues(propertyName: widget.propertyName);
          final projects = _projects.getProjects(propertyName: widget.propertyName);
          final events = _events.getEvents(propertyName: widget.propertyName);
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              96,
            ),
            children: [
              _WelcomeCard(
                propertyName: widget.propertyName,
                onPropertyChanged: widget.onPropertyChanged,
              ),
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(
                title: 'Management announcements',
                icon: Icons.campaign_outlined,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _AnnouncementCard(),
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(
                title: 'Trending discussions',
                icon: Icons.trending_up,
                action: 'See all',
                onAction: () => setState(() => _selectedTag = null),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_posts.trendingPosts(propertyName: widget.propertyName).isNotEmpty)
                PostCard(
                  post: _posts.trendingPosts(propertyName: widget.propertyName).first,
                ),
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(
                title: 'Community feed',
                icon: Icons.forum_outlined,
                action: 'New post',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TagFilters(
                selected: _selectedTag,
                onSelected: (tag) => setState(
                  () => _selectedTag = _selectedTag == tag ? null : tag,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (visiblePosts.isEmpty)
                const _EmptyCard(message: 'No posts for this topic yet.')
              else
                ...visiblePosts.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: PostCard(post: post),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              _SectionTitle(
                title: 'Recent issues',
                icon: Icons.handyman_outlined,
                action: 'View all',
                onAction: () => widget.onNavigate(1),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...issues.take(2).map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _IssuePreview(issue: issue),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionTitle(
                title: 'Upcoming events',
                icon: Icons.event_outlined,
                action: 'View all',
                onAction: () => widget.onNavigate(3),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...events.take(2).map(
                (event) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.event_available_outlined),
                    ),
                    title: Text(event.title),
                    subtitle: Text(
                      '${event.startsAt.day}/${event.startsAt.month} · ${event.location}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => widget.onNavigate(3),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionTitle(
                title: 'Recommended projects',
                icon: Icons.apartment_outlined,
                action: 'View all',
                onAction: () => widget.onNavigate(2),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...projects.take(2).map(
                (project) => _ProjectPreview(
                  project: project,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(project: project),
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

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.propertyName,
    required this.onPropertyChanged,
  });

  final String propertyName;
  final ValueChanged<String> onPropertyChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF3486E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, Jane',
            style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButton<String>(
            value: propertyName,
            dropdownColor: Colors.white,
            underline: const SizedBox.shrink(),
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            items: demoProperties
                .map(
                  (property) => DropdownMenuItem(
                    value: property,
                    child: Text(
                      property,
                      style: const TextStyle(color: Color(0xFF172033)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onPropertyChanged(value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white70, size: 18),
              SizedBox(width: AppSpacing.xs),
              Text('Your community, all in one place', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE6F1FF),
              child: Icon(Icons.campaign_outlined, color: AppTheme.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Management Office', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: AppSpacing.xs),
                  Text('Monthly maintenance update'),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Common-area inspections are scheduled this week. Please share any urgent concerns through the Issues tab.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    this.action,
    this.onAction,
  });

  final String title;
  final IconData icon;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class _TagFilters extends StatelessWidget {
  const _TagFilters({required this.selected, required this.onSelected});

  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const tags = ['Parking', 'Security', 'Facilities', 'Maintenance', 'Events', 'Community'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags
            .map(
              (tag) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: FilterChip(
                  label: Text('#$tag'),
                  selected: selected == tag,
                  onSelected: (_) => onSelected(tag),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _IssuePreview extends StatelessWidget {
  const _IssuePreview({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(issue.title),
        subtitle: Text('${issue.location} · ${issue.severity}'),
        trailing: IssueStatusBadge(status: issue.status),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => IssueDetailScreen(issue: issue)),
        ),
      ),
    );
  }
}

class _ProjectPreview extends StatelessWidget {
  const _ProjectPreview({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(project.title),
      subtitle: Text('${project.supportCount} residents support'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(message),
    ),
  );
}
