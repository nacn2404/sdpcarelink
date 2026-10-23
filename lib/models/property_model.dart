class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.name,
    required this.state,
    this.address = '',
    this.category = 'residential',
  });

  final String id;
  final String name;
  final String state;
  final String address;
  final String category;
}
