import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AddEventProvider>(
        builder: (context, eventProvider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  size: 17,
                ),
              ),
              title: const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildEventList(
                        eventProvider.events, 'No Upcoming Events yet!')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList(
      List<UpcomingEventsModel> upcomingEvents, String emptyEvents) {
    return upcomingEvents.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.event_busy_outlined,
                  size: 80,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  emptyEvents,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              final events = upcomingEvents[index];
              return EventsCard(
                upcomingEvents: events,
              );
            },
          );
  }
}

class EventsCard extends StatelessWidget {
  final UpcomingEventsModel upcomingEvents;

  const EventsCard({super.key, required this.upcomingEvents});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(
            '${LivingSeedRouter.accountPath}/${LivingSeedRouter.upcomingEventsPath}/${LivingSeedRouter.viewUpcomingEventsPath}',
            extra: upcomingEvents);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          upcomingEvents.eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${upcomingEvents.from.day.toString()}-${upcomingEvents.from.month.toString()}-${upcomingEvents.from.year.toString()} at ${upcomingEvents.from.hour.toString()}:${upcomingEvents.from.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${upcomingEvents.to.day.toString()}-${upcomingEvents.to.month.toString()}-${upcomingEvents.to.year.toString()} at ${upcomingEvents.to.hour.toString()}:${upcomingEvents.to.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                upcomingEvents.eventDetails,
                maxLines: 3,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: upcomingEvents.background,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
