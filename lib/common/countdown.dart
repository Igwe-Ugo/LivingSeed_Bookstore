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
    final targetTime = widget.nextEvent.to;

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
    if (!widget.nextEvent.to.isAfter(DateTime.now())) {
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Event Begin Date: ',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "${widget.nextEvent.from.day.toString()}-${widget.nextEvent.from.month.toString()}-${widget.nextEvent.from.year.toString()} at ${widget.nextEvent.from.hour.toString()}:${widget.nextEvent.from.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Event Ends Date: ',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "${widget.nextEvent.to.day.toString()}-${widget.nextEvent.to.month.toString()}-${widget.nextEvent.to.year.toString()} at ${widget.nextEvent.to.hour.toString()}:${widget.nextEvent.to.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(10, 50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                          child: Text(
                        'Register here',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Event is coming soon, do well to attend! Grace be with you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
