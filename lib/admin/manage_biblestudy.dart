import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BiblestudyManagement extends StatelessWidget {
  const BiblestudyManagement({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<BibleStudyProvider>(
        builder: (context, bibleStudyProvider, child) {
      final _allBiblestudy = bibleStudyProvider.allBibleStudies;
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
            'Manage Uploaded Biblestudy',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _allBiblestudy.isEmpty
            ? const Center(child: Text('No Bible Study uploaded yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _allBiblestudy.length,
                itemBuilder: (context, index) {
                  final bibleStudy = _allBiblestudy[index];
                  return _buildBookTile(context, bibleStudy);
                },
              ),
      );
    });
  }

  Widget _buildBookTile(BuildContext context, BibleStudyMaterial bibleStudy) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          leading: Image.asset(
            bibleStudy.coverImage,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Iconsax.book, size: 40),
          ),
          title: Text(bibleStudy.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text('# ${bibleStudy.amount.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Iconsax.edit_2, color: Colors.blue),
                onPressed: () {
                  if (bibleStudy != null) {
                    GoRouter.of(context).go(
                        '${LivingSeedRouter.accountPath}/${LivingSeedRouter.dashboardPath}/${LivingSeedRouter.manageBibleStudyPath}/${LivingSeedRouter.editBibleStudyPath}',
                        extra: bibleStudy);
                  }
                },
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Iconsax.trash, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, bibleStudy);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, BibleStudyMaterial bibleStudy) {
    final Uuid _uuid = const Uuid();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion',
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to delete "${bibleStudy.title}"?',
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
                action: 'BibleStudy Deleted',
                details:
                    'Title: ${bibleStudy.title}, Subtitle: ${bibleStudy.subTitle}',
                timestamp: DateTime.now(),
                icon: Icons.cancel_sharp,
              );
              NotificationItems newNotification = NotificationItems(
                notificationImage: bibleStudy.coverImage,
                notificationTitle: "${bibleStudy.title} Bible study Deleted",
                notificationMessage:
                    'The Bible Study titled ${bibleStudy.title} has been deleted successfully. It is not longer available!',
                notificationDate:
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                notificationTime:
                    "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
              );

              NotificationDropDownServices notificationId =
                  NotificationDropDownServices();

              Provider.of<BibleStudyProvider>(context, listen: false)
                  .deleteBiblestudy(bibleStudy.title);
              Provider.of<NotificationProvider>(context, listen: false)
                  .sendGeneralNotification(newNotification);
              NotificationDropDownServices.showNotification(
                  id: notificationId.getNextId(),
                  title: "${bibleStudy.title} deleted",
                  body:
                      'The bible study titled ${bibleStudy.title} has been deleted successfully.');
              Provider.of<AdminActivityService>(context, listen: false)
                  .logActivity(newActivity.action, newActivity.details,
                      newActivity.icon);
              showMessage(
                  'Simulated Deletion of "${bibleStudy.title}"', context);
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
