import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notificationTitleController =
      TextEditingController();
  final TextEditingController _notificationMessageController =
      TextEditingController();

  XFile? _coverImage;

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
            'Manage Notifications',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
          final generalNotices = notificationProvider.generalNotifications;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Notification',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ImagePickerDropZone(
                          title: 'Upload Cover Image',
                          icon: Iconsax.image,
                          color: Colors.green, // Kept original color
                          onFilePicked: (file) {
                            setState(() {
                              _coverImage = file as XFile;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextInput(
                            label: 'Message title...',
                            controller: _notificationTitleController,
                            icon: Icons.title,
                            validator: () {}),
                        CustomTextInput(
                          label: "Message",
                          controller: _notificationMessageController,
                          isIcon: false,
                          maxLine: 10,
                          maxLength: 700,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please give details about the notification made';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                          onPressed: () => _sendNotification(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Iconsax.message, color: Colors.white),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Send Notification',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const Text(
                    'Recent Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  generalNotices.isNotEmpty
                      ? Column(
                          children: generalNotices
                              .map((notice) => recentNotifications(context,
                                  notificationImage: notice.notificationImage,
                                  notificationTitle: notice.notificationTitle,
                                  notificationMessage:
                                      notice.notificationMessage,
                                  notificationDate: notice.notificationDate,
                                  notificationTime: notice.notificationTime,
                                  notificationData: notice))
                              .toList(),
                        )
                      : Center(
                          child: Column(
                            children: const [
                              SizedBox(
                                height: 40,
                              ),
                              Icon(
                                Iconsax.message_notif,
                                size: 80,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'No Recent Notifications Uploaded',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        }));
  }

  void _sendNotification() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }
    if (_coverImage!.path.isEmpty) {
      return showMessage(
          'Please share an image for this notification', context);
    }

    NotificationItems newNotification = NotificationItems(
      notificationImage: _coverImage!.path.toString(),
      notificationTitle: _notificationTitleController.text,
      notificationMessage: _notificationMessageController.text,
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );

    NotificationDropDownServices notificationId =
        NotificationDropDownServices();

    bool success =
        await Provider.of<NotificationProvider>(context, listen: false)
            .sendGeneralNotification(newNotification);

    AdminActivity newActivity = AdminActivity(
      id: notificationId.getNextId().toString(),
      action: 'Notification Sent',
      details:
          'Title: ${newNotification.notificationTitle}, Message: ${newNotification.notificationMessage.substring(0, 10)}...',
      timestamp: DateTime.now(),
      icon: Iconsax.message,
    );

    if (success) {
      Provider.of<AdminActivityService>(context, listen: false).logActivity(
          newActivity.action, newActivity.details, newActivity.icon);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "Notification sent!",
          body: _notificationMessageController.text.substring(0, 5));
      showMessage('Notification sent successfully!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage('Notification already exists, please send a new notification',
          context);
      return;
    }
  }

  Widget recentNotifications(BuildContext context,
      {required String notificationImage,
      required String notificationTitle,
      required String notificationMessage,
      required String notificationDate,
      required String notificationTime,
      required NotificationItems notificationData}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            GoRouter.of(context).go(
                '${LivingSeedRouter.accountPath}/${LivingSeedRouter.dashboardPath}/${LivingSeedRouter.manageNotificationsPath}/${LivingSeedRouter.anouncementsPath}',
                extra: notificationData);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 100,
                      width: 70,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(notificationImage),
                            fit: BoxFit.fill),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificationTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              notificationMessage,
                              maxLines: 3,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$notificationTime - $notificationDate',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 11.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  IconButton(
                    onPressed: () =>
                        _showDeleteConfirmation(context, notificationData),
                    icon: Icon(
                      Iconsax.trash,
                      color: Colors.red,
                      semanticLabel: 'delete notification',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 0.4,
        )
      ],
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, NotificationItems notification) {
    final Uuid _uuid = const Uuid();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion',
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: Text(
            'Are you sure you want to delete "${notification.notificationTitle} Notification for the whole app?"',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AdminActivity newActivity = AdminActivity(
                id: _uuid.v4(),
                action: 'Notification Deleted',
                details: 'Title: ${notification.notificationTitle}, by: Admin',
                timestamp: DateTime.now(),
                icon: Iconsax.trash,
              );
              Provider.of<AdminActivityService>(context, listen: false)
                  .logActivity(newActivity.action, newActivity.details,
                      newActivity.icon);
              Provider.of<NotificationProvider>(context, listen: false)
                  .deleteGeneralNotification(notification.notificationTitle);
              showMessage('Notification Deleted!', context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
