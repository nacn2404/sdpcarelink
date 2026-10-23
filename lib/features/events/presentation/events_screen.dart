import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/services/mock_repositories.dart';
import '../data/event_model.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({
    super.key,
    this.propertyName = 'Green Heights Residence',
  });

  final String propertyName;
  final MockEventRepository _repository = MockEventRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community events')),
      body: AnimatedBuilder(
        animation: _repository.changes,
        builder: (context, _) {
          final events = _repository.getEvents(propertyName: propertyName);
          if (events.isEmpty) return const _EmptyEvents();
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _EventCard(
              event: events[index],
              onRsvp: (response) =>
                  _repository.rsvp(events[index].id, response),
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onRsvp});

  final CommunityEvent event;
  final ValueChanged<String> onRsvp;

  @override
  Widget build(BuildContext context) {
    final date = event.startsAt;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F1FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _month(date.month),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${date.day}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${event.type} · ${_time(date)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(event.description),
            ],
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 17),
                  const SizedBox(width: AppSpacing.xs),
                  Text(event.location),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${event.participantCount} residents interested or going',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => onRsvp('interested'),
                  child: Text(
                    event.myRsvp == 'interested' ? 'Interested ✓' : 'Interested',
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                FilledButton(
                  onPressed: () => onRsvp('going'),
                  child: Text(event.myRsvp == 'going' ? 'Going ✓' : 'RSVP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_outlined, size: 48, color: Colors.black38),
            SizedBox(height: AppSpacing.md),
            Text('No upcoming events'),
            SizedBox(height: AppSpacing.xs),
            Text('Community events and notices will appear here.'),
          ],
        ),
      ),
    );
  }
}

String _month(int month) => const [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
][month - 1];

String _time(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
}
