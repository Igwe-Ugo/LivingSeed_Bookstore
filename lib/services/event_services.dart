import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:path_provider/path_provider.dart';

class AddEventProvider extends ChangeNotifier {
  List<UpcomingEventsModel> _events = [];
  UpcomingEventsModel? _selectedEvent; // Stores the selected event

  List<UpcomingEventsModel> get events => _events;
  UpcomingEventsModel? get selectedEvent => _selectedEvent;

  /// Select an event to show a tooltip
  void selectEvent(UpcomingEventsModel? event) {
    _selectedEvent = event;
    notifyListeners(); // Notify UI updates
  }

  /// Initialize events by loading from assets & local storage
  Future<void> initializeEvents() async {
    List<UpcomingEventsModel> localEvents = await _loadEventsFromLocal();

    _events = [...localEvents]; // Prioritize local storage
    notifyListeners();
  }

  /// Add a new event
  Future<void> addEvent(UpcomingEventsModel event) async {
    _events.add(event);
    await _saveEventsToLocal();
    notifyListeners();
  }

  /// Delete an event
  Future<void> deleteEvent(UpcomingEventsModel event) async {
    _events.remove(event);
    await _saveEventsToLocal();
    notifyListeners();
  }

  /// Load events from local storage
  Future<List<UpcomingEventsModel>> _loadEventsFromLocal() async {
    try {
      final file = await _getEventFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList
            .map((json) => UpcomingEventsModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading events from local storage: $e');
    }
    return [];
  }

  /// Save events to local storage
  Future<void> _saveEventsToLocal() async {
    try {
      final file = await _getEventFile();
      String jsonData =
          json.encode(_events.map((event) => event.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving events: $e');
    }
  }

  /// Get local file path for events
  Future<File> _getEventFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/events.json');
  }
}
