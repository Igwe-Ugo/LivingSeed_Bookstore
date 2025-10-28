import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

class ViewUpcomingEvents extends StatelessWidget {
  final UpcomingEventsModel upcomingEvents;
  const ViewUpcomingEvents({super.key, required this.upcomingEvents});

  @override
  Widget build(BuildContext context) {
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
          'Upcoming Event',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Column(
                  children: [
                    ImageFileAuth(
                        fileImage: upcomingEvents.eventImageUrl,
                        imageHeight: 350,
                        imageWidth: double.infinity),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      upcomingEvents.eventName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      upcomingEvents.eventDetails,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ],
                ),
              ),
              EventCountdown(
                  nextEvent: upcomingEvents,
                  primaryColor: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
