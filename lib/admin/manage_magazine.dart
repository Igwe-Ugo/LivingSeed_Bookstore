import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ManageMagazine extends StatelessWidget {
  const ManageMagazine({super.key});
  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch the list of ALL books here
    // List<AboutBooks> allBooks = Provider.of<BookProvider>(context).allBooks;

    return Consumer<MagazineProvider>(builder: (context, magazineProvider, child) {
      final _magazine = magazineProvider.magazines;
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
            'Manage Uploaded Magazines',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _magazine.isEmpty
            ? const Center(child: Text('No magazine uploaded yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _magazine.length,
                itemBuilder: (context, index) {
                  final magazine = _magazine[index];
                  return _buildBookTile(context, magazine);
                },
              ),
      );
    });
  }

  Widget _buildBookTile(BuildContext context, MagazineModel magazine) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          leading: Image.asset(
            magazine.coverImage,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Iconsax.book_1, size: 40),
          ),
          title: Text(magazine.magazineTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle:
              Text('by ${magazine.publisher} | \#${magazine.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Iconsax.edit_2, color: Colors.blue),
                onPressed: () {
                  if (magazine != null) {
                    GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageMagazinePath}/${LivingSeedMediaRouter.editMagazinePath}',
                        extra: magazine);
                  }
                },
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Iconsax.trash, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, magazine);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MagazineModel magazine) {
    final Uuid _uuid = const Uuid();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion',
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to delete "${magazine.magazineTitle}"?',
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
                action: 'Magazine Deleted',
                details: 'Title: ${magazine.magazineTitle}, Author: ',
                timestamp: DateTime.now(),
                icon: Icons.cancel_sharp,
              );
              NotificationItems newNotification = NotificationItems(
                notificationImage: magazine.coverImage,
                notificationTitle: "${magazine.magazineTitle} Magazine Deleted",
                notificationMessage:
                    'The Magazine titled ${magazine.magazineTitle} has been deleted successfully. It is not longer available!',
                notificationDate:
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                notificationTime:
                    "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
              );

              NotificationDropDownServices notificationId =
                  NotificationDropDownServices();

              Provider.of<BookProvider>(context, listen: false)
                  .deleteBook(magazine.magazineTitle);
              Provider.of<NotificationProvider>(context, listen: false)
                  .sendGeneralNotification(newNotification);
              NotificationDropDownServices.showNotification(
                  id: notificationId.getNextId(),
                  title: "${magazine.magazineTitle} deleted",
                  body:
                      'The Magazine titled ${magazine.magazineTitle} has been deleted successfully.');
              Provider.of<AdminActivityService>(context, listen: false)
                  .logActivity(newActivity.action, newActivity.details,
                      newActivity.icon);
              showMessage('Simulated Deletion of "${magazine.magazineTitle}"', context);
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
