import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';

class ActivityLogPage extends StatelessWidget {
  final AdminRecentActivity activity;
  // NOTE: Pass the book object if you can fetch it here, 
  // or just the ID and fetch it on the edit screen.
  // We'll use the ID and rely on GoRouter for navigation.

  const ActivityLogPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title, style: theme.textTheme.titleLarge),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Iconsax.arrow_left_2, size: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Details',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            _buildDetailRow(
                context, 'Action:', activity.title, Iconsax.activity),
            _buildDetailRow(context, 'Item:', activity.subtitle, Iconsax.book),
            _buildDetailRow(
              context,
              'Date:',
              activity.timestamp.toLocal().toString().substring(0, 16),
              Iconsax.calendar_tick,
            ),
            _buildDetailRow(
                context, 'Book ID:', activity.relatedBookId, Iconsax.tag),
            const SizedBox(height: 40),

            // --- Action Buttons ---
            // Only show actions if the activity is about creation or editing
            if (activity.title.contains('Book')) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the edit screen, passing the related book ID
                    // Assuming you have a route '/admin/edit-book/:bookId'
                    context.go('/admin/edit-book/${activity.relatedBookId}');
                  },
                  icon: const Icon(Iconsax.edit_2, color: Colors.white),
                  label: Text('Edit Book: ${activity.subtitle}',
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // You would implement a confirmation dialog here
                    _showDeleteConfirmation(context, activity);
                  },
                  icon: const Icon(Iconsax.trash, color: Colors.white),
                  label: Text('Delete Book: ${activity.subtitle}',
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.all(16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AdminRecentActivity activity) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to permanently delete the book "${activity.subtitle}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would call a book service to delete the book
              // and then log the deletion via UsersAuthProvider.
              // For now, we simulate success.
              // Provider.of<UsersAuthProvider>(context, listen: false)
              //     .logBookDeleted(activity.subtitle, activity.relatedBookId);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Simulated Deletion of "${activity.subtitle}"')),
              );
              context.pop(); // Close dialog
              context.pop(); // Go back to dashboard/home
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
