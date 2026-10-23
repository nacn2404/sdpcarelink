class Project {
  Project({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.description,
    required this.potentialImpacts,
    required this.mitigationMeasures,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    this.propertyName = 'Green Heights Residence',
    this.benefits = const [],
    this.risks = const [],
    this.estimatedTimeline = 'To be confirmed',
    this.supportCount = 0,
    this.opposeCount = 0,
    this.moreInfoCount = 0,
  });

  final String id;
  final String propertyId;
  final String propertyName;
  final String title;
  final String description;
  final String potentialImpacts;
  final String mitigationMeasures;
  final List<String> benefits;
  final List<String> risks;
  final String estimatedTimeline;
  final String createdBy;
  final String status;
  final DateTime createdAt;
  int supportCount;
  int opposeCount;
  int moreInfoCount;
  String? myVote;

  int get totalVotes => supportCount + opposeCount + moreInfoCount;
}
