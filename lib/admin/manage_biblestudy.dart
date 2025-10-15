import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

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
                        '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageBibleStudyPath}/${LivingSeedMediaRouter.editBibleStudyPath}',
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
              // 1. Delete the book from the main book list (e.g., BookProvider)
              // 2. Log the activity
              // Provider.of<UsersAuthProvider>(context, listen: false)
              //     .logBookDeleted(book.bookTitle, book.bookId);

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
