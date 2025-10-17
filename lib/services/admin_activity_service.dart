import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:livingseed_media/models/widget.dart';

class AdminActivityService extends ChangeNotifier {
  static const int _maxActivities = 20;
  List<AdminActivity> _activities = [];
  List<AdminActivity> get recentActivities => _activities;
  final Uuid _uuid = Uuid();
  
  // New state to track if initialization is complete
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // CONSTRUCTOR: No async call here!
  AdminActivityService() {
    // Start initialization when the provider is created
    initializeActivities(); 
  }

  // New asynchronous initialization function
  Future<void> initializeActivities() async {
    await _loadActivities();
    _isInitialized = true;
    notifyListeners(); // Notify listeners that initialization is complete
  }

  Future<File?> _getActivitiesFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/admin_activities.json');
    } catch (e) {
      debugPrint('Error getting application documents directory: $e');
      return null; // Return null if directory access fails
    }
  }

  Future<void> _loadActivities() async {
    final file = await _getActivitiesFile();
    if (file == null) return; // Exit if file path couldn't be determined

    try {
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        _activities = jsonList
            .map((item) => AdminActivity.fromJson(item))
            .toList()
            .cast<AdminActivity>();
        // ensure they are sorted by date (newest first)
        _activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _activities = _activities.take(_maxActivities).toList();
      }
    } catch (e) {
      // Catch exceptions during file read/decode
      debugPrint('Error loading local activity data: $e');
      _activities = []; // Reset activities to empty list on error
    }
    // Note: notifyListeners() is called in initialize()
  }

  Future<void> _saveActivitiesToLocal() async {
    if (!_isInitialized) return; // Only save if initialized
    final file = await _getActivitiesFile();
    if (file == null) return;
    
    try {
      String jsonData = json
          .encode(_activities.map((activity) => activity.toJson()).toList());
      await file.writeAsString(jsonData, mode: FileMode.write);
    } catch (e) {
      debugPrint('Error saving activity data: $e');
    }
  }

  // add a new activity and maintain the max limit of 20
  Future<void> logActivity(String action, String details, IconData icon) async {
    if (!_isInitialized) return; // Only log if initialized

    final newActivity = AdminActivity(
        id: _uuid.v4(),
        action: action,
        details: details,
        timestamp: DateTime.now(),
        icon: icon);
    // Add to the front of the list
    _activities.insert(0, newActivity);
    // keep only the last 20 activities
    if (_activities.length > _maxActivities) {
      _activities = _activities.take(_maxActivities).toList();
    }
    await _saveActivitiesToLocal();
    notifyListeners();
  }
}
