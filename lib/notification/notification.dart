// notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  // Helper method to build the notification list for a specific filter
  Widget _buildNotificationList(
      {required BuildContext context,
      required List<NotificationItems> allNotifications,
      required String userEmail}) {
    final userSpecificNotifications =
        allNotifications.where((n) => !n.isRead || n.isRead).toList();

    if (userSpecificNotifications.isEmpty) {
      return Center(
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
              'No New Notifications',
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
      );
    }

    // Use ListView.builder for the scrollable content inside TabBarView
    return ListView.builder(
      // The NestedScrollView handles the scrolling, so we don't need shrinkWrap or physics.
      itemCount: allNotifications.length,
      itemBuilder: (context, index) {
        final notification = userSpecificNotifications[index];
        return NotificationItemCard(
          notification: notification,
          onTap: () {
            GoRouter.of(context).go(
                '${LivingSeedRouter.notificationPath}/${LivingSeedRouter.anouncementsPath}',
                extra: notification);
            if (!notification.isRead) {
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAsRead(notification, userEmail);
            }
          },
        );
      },
    );
  }

  // Delegate class to make the TabBar sticky
  SliverPersistentHeaderDelegate _buildSliverDelegate(
      BuildContext context, TabBar tabBar) {
    return _SliverAppBarDelegate(
      tabBar,
      Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UsersAuthProvider, NotificationProvider>(
      builder: (context, userProvider, notificationProvider, child) {
        Users user = userProvider.userData!;
        // Ensure userData is not null before accessing it
        if (user == null) {
          return const SizedBox();
        }

        // 1. Wrap the Scaffold body in a DefaultTabController
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // 2. Use NestedScrollView for the sticky header and scrollable body
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  // --- Fixed Header Content ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
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
                                      'All Notifications marked as read!',
                                      context);
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
                  ),

                  // --- Sticky Tab Bar ---
                  SliverPersistentHeader(
                    pinned: true, // Makes the TabBar stick to the top
                    delegate: _buildSliverDelegate(
                      context,
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            fontFamily: 'Playfair',
                            color: Theme.of(context).primaryColor),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                        tabs: [
                          Tab(
                            child: Text(
                              'General',
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Personal',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },

              // 3. TabBarView for the main scrollable body content
              body: TabBarView(
                children: [
                  _buildNotificationList(
                      context: context,
                      allNotifications:
                          notificationProvider.generalNotifications,
                      userEmail: user.emailAddress),
                  _buildNotificationList(
                      context: context,
                      allNotifications: user.emailAddress != null
                          ? notificationProvider
                                  .personalNotifications[user.emailAddress] ??
                              []
                          : [],
                      userEmail: user.emailAddress),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Delegate for SliverPersistentHeader (Required for Sticky TabBar)
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._backgroundColor);

  final TabBar _tabBar;
  final Color _backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// Widget for displaying a single notification item (Same as before)
class NotificationItemCard extends StatelessWidget {
  final NotificationItems notification;
  final VoidCallback onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead
                ? Theme.of(context).cardColor
                : Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Image/Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(notification.notificationImage),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and Date/Time
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
