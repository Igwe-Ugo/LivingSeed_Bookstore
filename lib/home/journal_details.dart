import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/show_message.dart';
import '../models/journal_model.dart'; // Import the model

class JournalDetailScreen extends StatelessWidget {
  final JournalPost post;

  const JournalDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows content to go behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor:
            Colors.white, // White icons/text for contrast against the image
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: Text(
          post.title,
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Image and Overlay Section (Using Stack) ---
            _buildImageHeader(context),

            // --- 2. Journal Write-up and Title ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the Journal (Assuming the title is the first line of the write-up or inferred)
                  Text(
                    post.title, // Example title
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Playfair',
                        ),
                  ),
                  const Divider(height: 30),

                  // Journal Write-up
                  Text(
                    post.journalWriteup,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // --- 3. Comments Section ---
            _buildCommentsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background Image
        Container(
          height: 300,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            // Gradient overlay for better contrast on text
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.5)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Image.asset(
            post.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[600],
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported,
                  size: 60, color: Colors.white),
            ),
          ),
        ),

        // Overlay Container with Metadata
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors
                .transparent, // Transparent background as the gradient handles contrast
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Tag
                Chip(
                  label: Text(
                    post.category.toTitle(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: theme.primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(height: 8),

                // Author and Date Info
                Text(
                  'By ${post.authorName} | ${post.date.day}/${post.date.month}/${post.date.year}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments (${post.comments.length})',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),

          if (post.comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: Text('Be the first to leave a comment!')),
            ),

          // List of Comments
          ...post.comments
              .map((comment) => _buildCommentCard(context, comment)),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildCommentCard(BuildContext context, JournalComment comment) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Comment Author and Date
              Row(
                children: [
                  const Icon(Icons.person_pin, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    comment.personName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${comment.date.day}/${comment.date.month}/${comment.date.year})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              // Reply Button
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement reply functionality (e.g., show a text field/dialog)
                  showMessage(
                      "'Reply feature coming soon for ${comment.personName}!'",
                      context);
                },
                icon: Icon(
                  Icons.reply,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Reply',
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),

          // Comment Text
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 4.0),
            child: Text(
              comment.personComment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
