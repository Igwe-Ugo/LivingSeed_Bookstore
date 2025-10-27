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
                    SizedBox(
                      height: 40,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Event Begin Date: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "${upcomingEvents.from.day.toString()}-${upcomingEvents.from.month.toString()}-${upcomingEvents.from.year.toString()} at ${upcomingEvents.from.hour.toString()}:${upcomingEvents.from.minute.toString().padLeft(2, '0')}",
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
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "${upcomingEvents.to.day.toString()}-${upcomingEvents.to.month.toString()}-${upcomingEvents.to.year.toString()} at ${upcomingEvents.to.hour.toString()}:${upcomingEvents.to.minute.toString().padLeft(2, '0')}",
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
                  ],
                ),
              ),
              EventCountdown(
                  nextEvent: upcomingEvents,
                  primaryColor: Theme.of(context).primaryColor),
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
        ),
      ),
    );
  }
}
