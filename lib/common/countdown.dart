import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livingseed_media/models/widget.dart';

class EventCountdown extends StatefulWidget {
  final UpcomingEventsModel nextEvent;
  final Color primaryColor;

  const EventCountdown(
      {super.key, required this.nextEvent, required this.primaryColor});

  @override
  _EventCountdownState createState() => _EventCountdownState();
}

class _EventCountdownState extends State<EventCountdown> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _calculateTimeRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _calculateTimeRemaining();
    });
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    final targetTime = widget.nextEvent.from;

    // Check if the event is in the future
    if (targetTime.isAfter(now)) {
      setState(() {
        _timeRemaining = targetTime.difference(now);
      });
    } else {
      // Event has passed or is starting now
      setState(() {
        _timeRemaining = Duration.zero;
      });
      _timer?.cancel();
    }
    if (!widget.nextEvent.from.isAfter(DateTime.now())) {
      _timer?.cancel(); // Use the null-aware operator
    }
  }

  // Helper method to build the individual counter circles
  Widget _buildTimeSegment(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: widget.primaryColor.withOpacity(0.2), // Light green ring
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              color: widget.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: widget.primaryColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_timeRemaining == Duration.zero) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 80,
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              "Event Ended",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.nextEvent.eventName, // Use event name for title
            style: TextStyle(
              color: widget.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'This Program Holds',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'Playfair',
            ),
          ),
          Container(
            width: 30,
            height: 3,
            margin: const EdgeInsets.only(top: 8),
            color: widget.primaryColor, // Small green underline
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeSegment(days.toString().padLeft(2, '0'), 'Days'),
              const SizedBox(width: 10),
              _buildTimeSegment(hours.toString().padLeft(2, '0'), 'Hours'),
              const SizedBox(width: 10),
              _buildTimeSegment(minutes.toString().padLeft(2, '0'), 'Minutes'),
              const SizedBox(width: 10),
              _buildTimeSegment(seconds.toString().padLeft(2, '0'), 'Seconds'),
            ],
          ),
        ],
      ),
    );
  }
}
