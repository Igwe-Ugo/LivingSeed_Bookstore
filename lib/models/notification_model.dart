import 'dart:convert';

class NotificationItems {
  final String notificationImage;
  final String notificationTitle;
  final String notificationMessage;
  final String notificationDate;
  final String notificationTime;
  bool isRead;

  NotificationItems({
    required this.notificationImage,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.notificationDate,
    required this.notificationTime,
    this.isRead = false,
  });

  factory NotificationItems.fromJson(Map<String, dynamic> json) {
    return NotificationItems(
      notificationImage: json['notificationImage'],
      notificationTitle: json['notificationTitle'],
      notificationMessage: json['notificationMessage'],
      notificationDate: json['notificationDate'],
      notificationTime: json['notificationTime'],
      isRead: json['isRead'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationImage': notificationImage,
      'notificationTitle': notificationTitle,
      'notificationMessage': notificationMessage,
      'notificationDate': notificationDate,
      'notificationTime': notificationTime,
      'isRead': isRead
    };
  }
}

class Notice {
  final List<NotificationItems> generalNotifications;
  final Map<String, List<NotificationItems>> personalNotifications;

  Notice({
    required this.generalNotifications,
    required this.personalNotifications,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    // Parse general notifications list
    List<NotificationItems> general = (json['generalNotifications'] as List)
        .map((e) => NotificationItems.fromJson(e))
        .toList();

    // Parse personal notifications (which is a map of user emails to lists)
    Map<String, List<NotificationItems>> personal = {};
    json['personalNotifications'].forEach((email, notices) {
      personal[email] =
          (notices as List).map((e) => NotificationItems.fromJson(e)).toList();
    });

    return Notice(
      generalNotifications: general,
      personalNotifications: personal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'generalNotifications':
          generalNotifications.map((e) => e.toJson()).toList(),
      'personalNotifications': personalNotifications.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
    };
  }

  static Notice fromJsonString(String jsonString) {
    return Notice.fromJson(json.decode(jsonString));
  }

  static String toJsonString(Notice notifications) {
    return json.encode(notifications.toJson());
  }
}
