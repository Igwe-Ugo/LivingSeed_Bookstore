import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminAddEvent extends StatefulWidget {
  const AdminAddEvent({super.key});

  @override
  State<AdminAddEvent> createState() => _AdminAddEventState();
}

class _AdminAddEventState extends State<AdminAddEvent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddEventProvider>(builder: (context, eventProvider, child) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  size: 17,
                )),
            toolbarHeight: 70,
            title: Text(
              'Add Event',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => GoRouter.of(context).go(
                '${LivingSeedRouter.accountPath}/${LivingSeedRouter.dashboardPath}/${LivingSeedRouter.addEventPath}/${LivingSeedRouter.createEventPath}'),
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Iconsax.add,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: SfCalendar(
                  view: CalendarView.month,
                  todayHighlightColor: Theme.of(context).primaryColor,
                  todayTextStyle: TextStyle(
                      fontFamily: 'Playfair', fontWeight: FontWeight.bold),
                  showTodayButton: true,
                  showNavigationArrow: true,
                  headerHeight: 70,
                  dataSource: MeetingDataSource(eventProvider.events),
                  onTap: (CalendarTapDetails details) {
                    if (details.appointments != null &&
                        details.appointments!.isNotEmpty) {
                      // Select the first tapped event
                      eventProvider.selectEvent(details.appointments!.first);
                      GoRouter.of(context).go(
                          '${LivingSeedRouter.accountPath}/${LivingSeedRouter.dashboardPath}/${LivingSeedRouter.addEventPath}/${LivingSeedRouter.editEventPath}',
                          extra: eventProvider.selectedEvent!);
                    } else {
                      eventProvider.selectEvent(null); // Hide tooltip
                    }
                  },
                ),
              ),
            ],
          ));
    });
  }
}
