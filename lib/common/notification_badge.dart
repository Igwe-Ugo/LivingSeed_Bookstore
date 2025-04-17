import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

import '../models/users_model.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, UsersAuthProvider>(
        builder: (context, noticeProvider, userProvider, child) {
      if (userProvider.userData == null) {
        return const SizedBox();
      }
      Users user = userProvider.userData!;
      var unreadCount = noticeProvider.getUnreadCount(user.emailAddress);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Icon(Iconsax.message,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (unreadCount == 0) SizedBox.shrink()
          ],
        ),
      );
    });
  }
}
