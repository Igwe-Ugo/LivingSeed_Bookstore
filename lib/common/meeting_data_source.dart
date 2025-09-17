import 'package:flutter/material.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<UpcomingEventsModel> event) {
    appointments = event;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as UpcomingEventsModel).eventName;
  }

  @override
  Color getColor(int index) {
    return (appointments![index] as UpcomingEventsModel).background;
  }

  @override
  bool isAllDay(int index) {
    return (appointments![index] as UpcomingEventsModel).isAllDay;
  }

  String getDetails(int index) {
    return (appointments![index] as UpcomingEventsModel).eventDetails;
  }
}
