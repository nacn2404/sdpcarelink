class IssueTimelineEntry {
  const IssueTimelineEntry({
    required this.status,
    required this.date,
    this.note = '',
  });

  final String status;
  final DateTime date;
  final String note;
}

class Issue {
  Issue({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.reportedBy,
    required this.createdAt,
    required this.updatedAt,
    this.propertyName = 'Green Heights Residence',
    this.severity = 'Medium',
    this.imageUrls = const [],
    this.managementResponse = '',
    List<IssueTimelineEntry>? progressTimeline,
  }) : progressTimeline = progressTimeline ?? [
         IssueTimelineEntry(status: status, date: createdAt),
       ];

  final String id;
  final String propertyId;
  final String propertyName;
  final String title;
  final String description;
  final String category;
  final String location;
  String status;
  final String reportedBy;
  final String severity;
  final DateTime createdAt;
  DateTime updatedAt;
  final List<String> imageUrls;
  String managementResponse;
  final List<IssueTimelineEntry> progressTimeline;

  DateTime get dateReported => createdAt;
}

typedef IssueModel = Issue;
