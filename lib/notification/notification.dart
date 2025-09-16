// notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/widget.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UsersAuthProvider, NotificationProvider>(
      builder: (context, userProvider, notificationProvider, child) {
        // Ensure userData is not null before accessing it
        if (userProvider.userData == null) {
          return const SizedBox();
        }
        Users? user = userProvider.userData!;
        return Scaffold(
          body: SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/LSeed-Logo-1.png',
                        scale: 5,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'mark_all_read') {
                        bool success =
                            await notificationProvider.markAllAsRead();
                        if (success) {
                          showMessage(
                              'All Notifications marked as read!', context);
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'mark_all_read',
                        child: Text('Mark all as read'),
                      )
                    ],
                  )
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicatorColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            'General',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Personal',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        // General Notifications Tab
                        _buildNotificationsList(
                            notificationProvider.generalNotifications,
                            'No general notifications',
                            user.emailAddress),
                        // Personal Notifications Tab
                        _buildNotificationsList(
                            user.emailAddress != null
                                ? notificationProvider.personalNotifications[
                                        user.emailAddress] ??
                                    []
                                : [],
                            'No personal notifications',
                            user.emailAddress),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])),
        );
      },
    );
  }

  Widget _buildNotificationsList(List<NotificationItems> notifications,
      String emptyMessage, String userEmail) {
    return notifications.isEmpty
        ? Center(
            child: Column(
              children: [
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
                  emptyMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                userEmail: userEmail,
              );
            },
          );
  }
}

// notification_card.dart
class NotificationCard extends StatelessWidget {
  final NotificationItems notification;
  final String? userEmail;

  const NotificationCard(
      {super.key, required this.notification, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(
            '${LivingSeedMediaRouter.notificationPath}/${LivingSeedMediaRouter.anouncementsPath}',
            extra: notification);
        if (!notification.isRead) {
          Provider.of<NotificationProvider>(context, listen: false)
              .markAsRead(notification, userEmail);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: notification.isRead
            ? Colors.transparent
            : Theme.of(context).primaryColor.withAlpha(70),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    notification.notificationImage,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.notification_important, size: 40);
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.notificationTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              notification.notificationDate,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.notificationTime,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.notificationMessage,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
