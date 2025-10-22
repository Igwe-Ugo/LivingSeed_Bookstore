import 'package:flutter/material.dart';

class UpcomingEventsModel {
  String id = UniqueKey().toString();
  String eventImageUrl;
  String eventName;
  String eventVenue;
  String eventDetails;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  UpcomingEventsModel({
    required this.eventImageUrl,
    required this.eventName,
    required this.eventVenue,
    required this.eventDetails,
    required this.from,
    required this.to,
    this.background = Colors.deepOrangeAccent,
    this.isAllDay = false,
  });

  factory UpcomingEventsModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventsModel(
      eventImageUrl: json['eventImageUrl'],
      eventName: json['eventName'],
      eventVenue: json['eventVenue'],
      eventDetails: json['eventDetails'],
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      background: Color(json['background']),
      isAllDay: json['isAllDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventImageUrl': eventImageUrl,
      'eventName': eventName,
      'eventVenue': eventVenue,
      'eventDetails': eventDetails,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'background': background.value,
      'isAllDay': isAllDay,
    };
  }
}
