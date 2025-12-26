class UserModel {
  final int id;
  final String name;
  final bool isOnline;
  final DateTime lastSeen;

  const UserModel({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.lastSeen,
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
}
