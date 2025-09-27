import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
    List<NotificationItems> _generalNotifications = [];
  Map<String, List<NotificationItems>> _personalNotifications = {};

  List<NotificationItems> get generalNotifications => _generalNotifications;
  Map<String, List<NotificationItems>> get personalNotifications =>
      _personalNotifications;

  int getUnreadCount(String? userEmail) {
    int generalUnread = _generalNotifications.where((n) => !n.isRead).length;
    if (userEmail == null || !_personalNotifications.containsKey(userEmail)) {
      return generalUnread;
    }
    int personalUnread =
        _personalNotifications[userEmail]!.where((n) => !n.isRead).length;
    return generalUnread + personalUnread;
  }

  Future<void> initializeNotifications() async {
    try {
      await _loadAllNotifications();
      await _applyReadStatus();
      notifyListeners();
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> _loadAllNotifications() async {
    await Future.wait(
        [_loadGeneralNotifications(), _loadPersonalNotifications()]);
  }

  Future<void> _loadGeneralNotifications() async {
    try {
      final List<NotificationItems> assetNotifications =
          await _loadFromAssets('generalNotifications');
      final List<NotificationItems> localNotifications =
          await _loadFromLocal('generalNotifications');

      Set<String> existingTitles =
          localNotifications.map((n) => n.notificationTitle).toSet();
      assetNotifications
          .removeWhere((n) => existingTitles.contains(n.notificationTitle));

      _generalNotifications = [...localNotifications, ...assetNotifications];
    } catch (e) {
      debugPrint('Error loading general notifications: $e');
      _generalNotifications = [];
    }
  }

  Future<void> _loadPersonalNotifications() async {
    try {
      final Map<String, List<NotificationItems>> assetNotifications =
          await _loadFromAssets('personalNotifications');
      final Map<String, List<NotificationItems>> localNotifications =
          await _loadFromLocal('personalNotifications');

      _personalNotifications = {...localNotifications};
      assetNotifications.forEach((email, notifications) {
        if (!_personalNotifications.containsKey(email)) {
          _personalNotifications[email] = notifications;
        }
      });
    } catch (e) {
      debugPrint('Error loading personal notifications: $e');
      _personalNotifications = {};
    }
  }

  Future<dynamic> _loadFromAssets(String type) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/notifications.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      if (type == 'generalNotifications') {
        return (jsonData[type] as List)
            .map((item) => NotificationItems.fromJson(item))
            .toList();
      } else {
        final Map<String, dynamic> personalData = jsonData[type];
        return Map.fromEntries(personalData.entries.map((e) => MapEntry(
            e.key,
            (e.value as List)
                .map((item) => NotificationItems.fromJson(item))
                .toList())));
      }
    } catch (e) {
      debugPrint('Error loading from assets: $e');
      return type == 'generalNotifications' ? [] : {};
    }
  }

  Future<dynamic> _loadFromLocal(String type) async {
    try {
      final file = await _getNotificationFile();
      if (!file.existsSync()) return type == 'generalNotifications' ? [] : {};

      final String data = await file.readAsString();
      final Map<String, dynamic> jsonData = json.decode(data);

      if (type == 'generalNotifications') {
        return (jsonData[type] as List)
            .map((item) => NotificationItems.fromJson(item))
            .toList();
      } else {
        final Map<String, dynamic> personalData = jsonData[type];
        return Map.fromEntries(personalData.entries.map((e) => MapEntry(
            e.key,
            (e.value as List)
                .map((item) => NotificationItems.fromJson(item))
                .toList())));
      }
    } catch (e) {
      debugPrint('Error loading from local: $e');
      return type == 'generalNotifications' ? [] : {};
    }
  }

  Future<File> _getNotificationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  Future<void> _saveNotificationsToLocal() async {
    try {
      final file = await _getNotificationFile();
      final Map<String, dynamic> data = {
        'generalNotifications':
            _generalNotifications.map((n) => n.toJson()).toList(),
        'personalNotifications': _personalNotifications.map((key, value) =>
            MapEntry(key, value.map((n) => n.toJson()).toList()))
      };
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  Future<void> _applyReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? readStatusString = prefs.getString('read_status');

      if (readStatusString == null || readStatusString.isEmpty) {
        return; // No saved read status
      }

      final Map<String, dynamic> decodedData = json.decode(readStatusString);

      // Convert dynamic values to bool explicitly
      final Map<String, bool> readStatus = {};
      decodedData.forEach((key, value) {
        if (value is bool) {
          readStatus[key] = value;
        } else {
          // Handle non-boolean values (could be stored as int 0/1 or string)
          readStatus[key] =
              value == true || value == 1 || value == '1' || value == 'true';
        }
      });

      for (var notification in _generalNotifications) {
        notification.isRead =
            readStatus[notification.notificationTitle] ?? false;
      }

      _personalNotifications.forEach((email, notifications) {
        for (var notification in notifications) {
          notification.isRead =
              readStatus[notification.notificationTitle] ?? false;
        }
      });
    } catch (e) {
      debugPrint('Error applying read status: $e');
    }
  }

  Future<void> _saveReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, bool> readStatus = {};

      for (var notification in _generalNotifications) {
        readStatus[notification.notificationTitle] = notification.isRead;
      }

      _personalNotifications.forEach((email, notifications) {
        for (var notification in notifications) {
          readStatus[notification.notificationTitle] = notification.isRead;
        }
      });

      // convert to a simple Map<String, bool> structure that serializes cleanly
      final Map<String, dynamic> jsonReadyMap = {};
      readStatus.forEach((key, value) {
        jsonReadyMap[key] = value;
      });

      await prefs.setString('read_status', json.encode(readStatus));
    } catch (e) {
      debugPrint('Error saving read status: $e');
    }
  }

  Future<bool> markAsRead(
      NotificationItems notification, String? userEmail) async {
    try {
      bool found = false;

      if (_generalNotifications.contains(notification)) {
        _generalNotifications[_generalNotifications.indexOf(notification)]
            .isRead = true;
        found = true;
      } else if (userEmail != null &&
          _personalNotifications.containsKey(userEmail)) {
        final userNotifications = _personalNotifications[userEmail]!;
        if (userNotifications.contains(notification)) {
          userNotifications[userNotifications.indexOf(notification)].isRead =
              true;
          found = true;
        }
      }

      if (found) {
        await _saveReadStatus();
        await _saveNotificationsToLocal();
        notifyListeners();
      }
      return found;
    } catch (e) {
      debugPrint('Error marking as read: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      // for general notification
      for (var notify in _generalNotifications) {
        notify.isRead = true;
      }

      // for personal notification
      _personalNotifications.forEach((email, notification) {
        for (var notify in notification) {
          notify.isRead = true;
        }
      });
      await _saveReadStatus();
      await _saveNotificationsToLocal();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error marking all the notifications as read: $e');
      return false;
    }
  }

  Future<bool> sendGeneralNotification(
      NotificationItems newNotification) async {
    try {
      if (_generalNotifications.any(
          (n) => n.notificationTitle == newNotification.notificationTitle)) {
        return false;
      }
      _generalNotifications.add(newNotification);
      await _saveNotificationsToLocal();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error sending general notification: $e');
      return false;
    }
  }

  Future<bool> sendPersonalNotification(
      String email, NotificationItems newNotification) async {
    try {
      _personalNotifications.putIfAbsent(email, () => []);
      _personalNotifications[email]!.add(newNotification);
      await _saveNotificationsToLocal();
      notifyListeners();
      return true;
    } catch (e, trace) {
      print(trace);
      debugPrint('Error sending personal notification: $e');
      return false;
    }
  }

  // delete general notification
  Future<bool> deleteGeneralNotification(String notificationTitle) async {
    int initialLength = _generalNotifications.length;
    _generalNotifications
        .removeWhere((n) => n.notificationTitle == notificationTitle);
    if (_generalNotifications.length != initialLength) {
      await _saveNotificationsToLocal();
      notifyListeners();
      return true;
    }
    return false;
  }

  // delete personal notification for a user
  Future<bool> deletePersonalNotification(
      String email, String notificationTitle) async {
    if (_personalNotifications.containsKey(email)) {
      int initialLength = _personalNotifications[email]!.length;
      _personalNotifications[email]!
          .removeWhere((n) => n.notificationTitle == notificationTitle);
      if (_personalNotifications[email]!.isEmpty) {
        _personalNotifications.remove(email);
      }
      if (_personalNotifications.length != initialLength) {
        await _saveNotificationsToLocal();
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}

class NotificationDropDownServices {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static int _counter = 0;
  
  // initialize the notification plugin
  static Future<void> initNotificationsDropDown() async {
    
    // 1. MOBILE SETTINGS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // replace with app icon
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // 2. DESKTOP SETTINGS (Crucial for fixing the Linux error)
    // You must provide an app name for desktop initializations.
    // The details required here are minimal, but the object must exist.
    
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // Add placeholders for desktop environments to satisfy the Linux plugin
      linux: const LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      ),
      // Adding macOS and Windows for robustness if you target those later
      macOS: initializationSettingsIOS, 
      windows: null, // Windows initialization is often configured lazily or not needed for simple dropdowns
    );

    // Note: We don't need to check the platform here; the plugin handles
    // initializing only the relevant platform.
    await _notificationsPlugin.initialize(initializationSettings);
  }

  // notifications ids generated
  int getNextId() {
    _counter++;
    return _counter;
  }

  // show notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main notification channel',
      importance: Importance.max,
      priority: Priority.high,
      // For persistent notifications that appear in the system tray on desktop/web:
      // You may need to specify platform-specific options for desktop platforms in the NotificationDetails object.
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(), // Add Linux details
    );

    await _notificationsPlugin.show(id, title, body, details);
  }

  // cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}