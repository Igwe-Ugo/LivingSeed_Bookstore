import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class JournalManagement extends StatelessWidget {
  const JournalManagement({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
      final _allBooks = journalProvider.allPosts;
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
            'Manage Journals',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _allBooks.isEmpty
            ? const Center(child: Text('No Journal uploaded yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _allBooks.length,
                itemBuilder: (context, index) {
                  final book = _allBooks[index];
                  return _buildJournalTile(context, book);
                },
              ),
      );
    });
  }

  Widget _buildJournalTile(BuildContext context, JournalPost journal) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          leading: Image.asset(
            journal.imageUrl,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Iconsax.book, size: 40),
          ),
          title: Text(journal.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('by ${journal.authorName}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Iconsax.edit_2, color: Colors.blue),
                onPressed: () {
                  if (journal != null) {
                    GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageJournalPath}/${LivingSeedMediaRouter.editJournalPath}',
                        extra: journal);
                  }
                },
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Iconsax.trash, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, journal);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, JournalPost journal) {
    final Uuid _uuid = const Uuid();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion',
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to delete "${journal.title}"?',
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
              NotificationItems newNotification = NotificationItems(
                notificationImage: journal.imageUrl,
                notificationTitle: "${journal.title} Journal Deleted",
                notificationMessage:
                    'The Journal titled ${journal.title} has been deleted successfully. It is not longer available!',
                notificationDate:
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                notificationTime:
                    "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
              );

              NotificationDropDownServices notificationId =
                  NotificationDropDownServices();

              AdminActivity newActivity = AdminActivity(
                id: _uuid.v4(),
                action: 'Journal Deleted',
                details:
                    'Title: ${journal.title}, author: ${journal.authorName}',
                timestamp: DateTime.now(),
                icon: Icons.cancel_sharp,
              );
              Provider.of<JournalProvider>(context, listen: false)
                  .deleteJournal(journal.title);
              Provider.of<AdminActivityService>(context, listen: false)
                  .logActivity(newActivity.action, newActivity.details,
                      newActivity.icon);
              Provider.of<NotificationProvider>(context, listen: false)
                  .sendGeneralNotification(newNotification);
              NotificationDropDownServices.showNotification(
                  id: notificationId.getNextId(),
                  title: "${journal.title} deleted",
                  body:
                      'The journal titled ${journal.title} has been deleted successfully.');
              showMessage('Simulated Deletion of "${journal.title}"', context);
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
