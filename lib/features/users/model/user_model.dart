class UserModel {
  final String id;
  final String name;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  String get lastSeenText {
    if (isOnline) return 'Online';

    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hrs ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      isOnline: json['isOnline'],
      lastSeen: DateTime.parse(json['lastSeen']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}