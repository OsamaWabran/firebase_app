class NotificationEntity {
  const NotificationEntity({required this.title, required this.body});

  final String title;
  final String body;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NotificationEntity &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode => Object.hash(title, body);
}
