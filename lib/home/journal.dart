import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  // Initialize with a default category, usually the first one or a special "All" category.
  JournalCategory _selectedCategory = JournalCategory.gleanings;

  @override
  Widget build(BuildContext context) {
    // Watch the JournalProvider for real-time updates to the list
    final journalProvider = context.watch<JournalProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: const Text(
          'Living Journals',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<JournalPost>>(
        // Wait for the initial loading of posts to complete
        future: journalProvider.postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No journal posts found.'));
          }

          // Data is loaded, now filter it based on the current state
          final filteredPosts =
              journalProvider.getPostsByCategory(_selectedCategory);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Category Filter Chips ---
              _buildCategoryChips(context),

              // --- Filtered Journal List ---
              Expanded(
                child: filteredPosts.isEmpty
                    ? Center(
                        child: Text(
                            'No posts in ${_selectedCategory.toTitle()} category.'))
                    : ListView.builder(
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = filteredPosts[index];
                          return _buildJournalCard(context, post);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildCategoryChips(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 10.0,
          children: JournalCategory.values.map((category) {
            return ChoiceChip(
              label: Text(category.toTitle()),
              selected: _selectedCategory == category,
              selectedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context, JournalPost post) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(
            '${LivingSeedMediaRouter.homePath}/${LivingSeedMediaRouter.journalDetailsPath}',
            extra: post);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category & Date Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.category.toTitle(),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${post.date.day}/${post.date.month}/${post.date.year}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Image (Placeholder)
              if (post.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    post.imageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Text('Image Not Found',
                          style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Playfair',
                    fontSize: 18),
              ),
              const SizedBox(height: 14),

              // Write-up Snippet
              Text(
                post.journalWriteup,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              // Footer (Author & Comments Count)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By ${post.authorName}',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement navigation to Journal Detail Screen
                    },
                    icon: Icon(
                      Icons.comment,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    label: Text(
                      '${post.comments.length} Comments',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
