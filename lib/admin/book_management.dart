import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BookManagement extends StatelessWidget {
  const BookManagement({super.key});
  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch the list of ALL books here
    // List<AboutBooks> allBooks = Provider.of<BookProvider>(context).allBooks;

    return Consumer<BookProvider>(builder: (context, bookProvider, child) {
      final _allBooks = bookProvider.allBooks;
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
            'Manage Uploaded Books',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _allBooks.isEmpty
            ? const Center(child: Text('No books uploaded yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _allBooks.length,
                itemBuilder: (context, index) {
                  final book = _allBooks[index];
                  return _buildBookTile(context, book);
                },
              ),
      );
    });
  }

  Widget _buildBookTile(BuildContext context, AboutBooks book) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          leading: Image.asset(
            book.coverImage,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Iconsax.book, size: 40),
          ),
          title: Text(book.bookTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle:
              Text('by ${book.author} | \#${book.amount.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Iconsax.edit_2, color: Colors.blue),
                onPressed: () {
                  if (book != null) {
                    GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageBooksPath}/${LivingSeedMediaRouter.editBookPath}',
                        extra: book);
                  }
                },
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Iconsax.trash, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, book);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AboutBooks book) {
    final Uuid _uuid = const Uuid();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion',
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to delete "${book.bookTitle}"?',
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
                action: 'Book Deleted',
                details: 'Title: ${book.bookTitle}, Author: ${book.author}',
                timestamp: DateTime.now(),
                icon: Icons.cancel_sharp,
              );
              Provider.of<BookProvider>(context, listen: false)
                  .deleteBook(book.bookTitle);
              Provider.of<AdminActivityService>(context, listen: false)
                  .logActivity(newActivity.action, newActivity.details,
                      newActivity.icon);
              showMessage('Simulated Deletion of "${book.bookTitle}"', context);
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
