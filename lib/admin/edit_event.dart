import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart'; 
import 'package:livingseed_media/models/widget.dart'; // Contains UpcomingEventsModel
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditEvent extends StatelessWidget {
  final UpcomingEventsModel upcomingEvents;
  const EditEvent({super.key, required this.upcomingEvents});
  void _deleteEvent(BuildContext context) {
    // Collect data for logging and notification
    AdminActivity newActivity = AdminActivity(
      id: const Uuid().v4(),
      action: 'Event Deleted',
      details:
          'Title: ${upcomingEvents.eventName}, Details: ${upcomingEvents.eventDetails}',
      timestamp: DateTime.now(),
      icon: Icons.cancel_sharp,
    );
    
    // Format notification date/time string
    final now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    NotificationItems newNotification = NotificationItems(
      notificationImage: upcomingEvents.eventImageUrl,
      notificationTitle: "${upcomingEvents.eventName} Event Deleted",
      notificationMessage:
          'The Event titled ${upcomingEvents.eventName} has been deleted successfully. It is no longer available!',
      notificationDate: "${now.day}-${now.month}-${now.year}",
      notificationTime: formattedTime,
    );

    NotificationDropDownServices notificationId = NotificationDropDownServices();

    // Execute deletions and logging
    Provider.of<AddEventProvider>(context, listen: false)
        .deleteEvent(upcomingEvents);
    Provider.of<NotificationProvider>(context, listen: false)
        .sendGeneralNotification(newNotification);
    NotificationDropDownServices.showNotification(
        id: notificationId.getNextId(),
        title: "${upcomingEvents.eventName} deleted",
        body:
            'The event titled ${upcomingEvents.eventName} has been deleted successfully.');
    Provider.of<AdminActivityService>(context, listen: false)
        .logActivity(newActivity.action, newActivity.details, newActivity.icon);
    
    // Show success message and navigate back
    showMessage(
        'The event "${upcomingEvents.eventName}" has been deleted.',
        context);
    context.pop(); // Pop back to the previous screen
  }

  // --- Pop-up Confirmation Dialog for Deletion ---
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete the event "${upcomingEvents.eventName}"?',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                _deleteEvent(context); // Then execute deletion logic
              },
            ),
          ],
        );
      },
    );
  }
  
  // --- Placeholder for navigating to the Edit Form ---
  void _navigateToEditForm(BuildContext context) {
    // In a real application, you would navigate to your dedicated edit screen here.
    // Example: GoRouter.of(context).push('/edit-event-form', extra: upcomingEvents);
    showMessage('Navigating to the Edit Form for "${upcomingEvents.eventName}"', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: Text(
          upcomingEvents.eventName,
          style: const TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // 1. Updated Delete Button to show Confirmation Dialog
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(Iconsax.trash, color: Colors.red),
          ),
        ],
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      upcomingEvents.eventName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      upcomingEvents.eventDetails,
                      textAlign: TextAlign.justify,
                      style:
                          const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Event Date: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          // Display date and time for better clarity
                          '${upcomingEvents.from.day}-${upcomingEvents.from.month}-${upcomingEvents.from.year} @ ${upcomingEvents.from.hour}:${upcomingEvents.from.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // Spacing before the button
                    
                    // 2. Added Edit Button
                    ElevatedButton.icon(
                      onPressed: () => _navigateToEditForm(context),
                      icon: const Icon(Iconsax.edit, color: Colors.white),
                      label: const Text(
                        'Edit Event Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
