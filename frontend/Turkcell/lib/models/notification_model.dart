class NotificationModel {
  final String notificationId;
  final String channel;
  final String message;
  final DateTime? sentAt;
  final bool? isRead;

  NotificationModel({
    required this.notificationId,
    required this.channel,
    required this.message,
    this.sentAt,
    this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? json['id'] ?? '',
      channel: json['channel'] ?? 'BiP',
      message: json['message'] ?? json['text'] ?? '',
      sentAt: json['sentAt'] != null 
          ? DateTime.tryParse(json['sentAt'])
          : null,
      isRead: json['isRead'] ?? json['read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'channel': channel,
      'message': message,
      'sentAt': sentAt?.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Helper to check if notification is recent (within last 24 hours)
  bool get isRecent {
    if (sentAt == null) return true; // Treat null as recent
    final now = DateTime.now();
    final difference = now.difference(sentAt!);
    return difference.inHours < 24;
  }

  // Helper to check if notification is today
  bool get isToday {
    if (sentAt == null) return false;
    final now = DateTime.now();
    return sentAt!.year == now.year &&
           sentAt!.month == now.month &&
           sentAt!.day == now.day;
  }
}