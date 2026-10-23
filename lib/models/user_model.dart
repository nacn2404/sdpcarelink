class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.propertyId,
    this.propertyName = 'Green Heights Residence',
    this.role = 'resident',
    this.residentSince = 2024,
    this.participationPoints = 135,
    this.badges = const [
      'Community Helper',
      'Top Contributor',
      'Active Resident',
      'Neighborhood Guardian',
    ],
  });

  final String id;
  final String name;
  final String email;
  final String? propertyId;
  final String propertyName;
  final String role;
  final int residentSince;
  final int participationPoints;
  final List<String> badges;
}
