class CategoryModel {
  final String name;
  final String icon;
  final String type; 

  CategoryModel({
    required this.name,
    required this.icon,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'type': type,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      icon: map['icon'] ?? '📦',
      type: map['type'] ?? 'expense',
    );
  }
}