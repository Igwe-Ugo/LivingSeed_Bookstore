import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class JournalDetailScreen extends StatefulWidget {
  final JournalPost post;

  const JournalDetailScreen({super.key, required this.post});

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersAuthProvider>(builder: (context, userProvider, child) {
      Users currentUser = userProvider.userData!;
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
            widget.post.title,
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
                      widget.post.title, // Example title
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Playfair',
                              ),
                    ),
                    const Divider(height: 30),

                    // Journal Write-up
                    Text(
                      widget.post.journalWriteup,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // --- 3. Comments Section ---
              _buildCommentsSection(context, currentUser, widget.post),
            ],
          ),
        ),
      );
    });
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
            widget.post.imageUrl,
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
                    widget.post.category.toTitle(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: theme.primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(height: 8),

                // Author and Date Info
                Text(
                  'By ${widget.post.authorName} | ${widget.post.date.day}/${widget.post.date.month}/${widget.post.date.year}',
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

  Widget _buildCommentsSection(
      BuildContext context, Users currentUser, JournalPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments (${widget.post.comments.length})',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),

          if (widget.post.comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: Text('Be the first to leave a comment!')),
            ),

          // List of Comments
          ...widget.post.comments
              .map((comment) => _buildCommentCard(context, comment)),

          const SizedBox(height: 30),
          CustomTextInput(
            label: "Add a comment",
            controller: _commentController,
            isIcon: false,
            maxLine: 10,
            maxLength: 700,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please add a comment';
              }
              return null;
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                _submitComment(currentUser, post);
              },
              icon: const Icon(Iconsax.send_sqaure_2, color: Colors.white),
              label: Text(
                'Comment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
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

          // --- ADDED: Replies Widget ---
          if (comment.replies.isNotEmpty)
            _buildRepliesSection(context, comment.replies),
          // --- END ADDED ---

          const Divider(height: 1),
        ],
      ),
    );
  }

  // --- ADDED: New Widget to build the list of replies ---
  Widget _buildRepliesSection(
      BuildContext context, List<JournalReplyComment> replies) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: replies.map((reply) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.subdirectory_arrow_right,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reply.replierName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${reply.replyDate.day}/${reply.replyDate.month}/${reply.replyDate.year})',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      Text(
                        reply.replyContent,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _submitComment(Users user, JournalPost post) {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      showMessage('Please enter a comment before submitting.', context);
      return;
    }
    NotificationItems newNotification = NotificationItems(
      notificationImage: post.imageUrl,
      notificationTitle: 'Comment made on a Journal',
      notificationMessage:
          '${user.fullname} has added a comment on the journal written by ${post.authorName} in the journal titled: ${post.title}!\n\nYou might want to check it out.',
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );
    Provider.of<NotificationProvider>(context, listen: false)
        .sendGeneralNotification(newNotification);

    final newComment = JournalComment(
      personName: user.fullname,
      date: DateTime.now(),
      personComment: commentText,
    );

    setState(() {
      widget.post.comments.add(newComment);
      _commentController.clear();
    });

    showMessage('Comment added successfully!', context);
  }
}
