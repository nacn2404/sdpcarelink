class CommunityEvent {
  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.propertyId,
    required this.startsAt,
    this.propertyName = 'Green Heights Residence',
    this.location = '',
    this.type = 'Community event',
    this.participantCount = 0,
  });

  final String id;
  final String title;
  final String description;
  final String propertyId;
  final String propertyName;
  final DateTime startsAt;
  final String location;
  final String type;
  int participantCount;
  String? myRsvp;
}
