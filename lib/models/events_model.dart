import 'package:flutter/material.dart';

class UpcomingEventsModel {
  String eventName;
  String eventDetails;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  UpcomingEventsModel({
    required this.eventName,
    required this.eventDetails,
    required this.from,
    required this.to,
    this.background = Colors.deepOrangeAccent,
    this.isAllDay = false,
  });

  factory UpcomingEventsModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventsModel(
      eventName: json['eventName'],
      eventDetails: json['eventDetails'],
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      background: Color(json['background']),
      isAllDay: json['isAllDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'eventDetails': eventDetails,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'background': background.value,
      'isAllDay': isAllDay,
    };
  }
}
