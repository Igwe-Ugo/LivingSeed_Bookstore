import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';
import 'package:uuid/uuid.dart';

class WriteJournal extends StatefulWidget {
  const WriteJournal({super.key});

  @override
  State<WriteJournal> createState() => _WriteJournalState();
}

class _WriteJournalState extends State<WriteJournal> {
  final Uuid _uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();

  // State for category selection (Crucial for the admin's choice)
  JournalCategory _selectedCategory = JournalCategory.gleanings;

  DateTime articleDate = DateTime.now();
  String?
      selectedArticleCategory; // This variable seems redundant now, relying on _selectedCategory

  // --- File Handling State ---
  XFile? _coverImage;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _articleController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  // RENAMED: Upload Journal Post function
  void _uploadJournalPost() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    // Validate file path
    if (_coverImage == null) {
      return showMessage('Please select a cover image', context);
    }

    // 1. Create the new JournalPost object
    final newPost = JournalPost(
      id: _uuid.v4(), // Generate unique ID
      title: _titleController.text.trim(),
      authorName: _authorController.text.trim(),
      imageUrl: _coverImage!.path,
      date: articleDate,
      category: _selectedCategory, // Use the selected category here!
      journalWriteup: _articleController.text.trim(),
      comments: [], // New post starts with no comments
    );
    NotificationItems newNotification = NotificationItems(
      notificationImage: newPost.imageUrl,
      notificationTitle: "${newPost.title} Journal Uploaded",
      notificationMessage:
          'The Journal titled ${newPost.title} has been uploaded successfully. You may want to read through it!',
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );

    NotificationDropDownServices notificationId =
        NotificationDropDownServices();

    AdminActivity newActivity = AdminActivity(
      id: _uuid.v4(),
      action: 'Journal uploaded',
      details: 'Title: ${newPost.title}, author: ${newPost.authorName}',
      timestamp: DateTime.now(),
      icon: Icons.upload_file,
    );

    try {
      final journalProvider =
          Provider.of<JournalProvider>(context, listen: false);

      await journalProvider.addJournalPost(newPost);
      Provider.of<AdminActivityService>(context, listen: false).logActivity(
          newActivity.action, newActivity.details, newActivity.icon);
      Provider.of<NotificationProvider>(context, listen: false)
          .sendGeneralNotification(newNotification);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "${newPost.title} uploaded",
          body:
              'The journal titled ${newPost.title} has been uploaded successfully.');
      showMessage('Journal Article uploaded successfully!', context);
      _titleController.clear();
      _authorController.clear();
      _articleController.clear();
      setState(() {
        _coverImage = null;
        _selectedCategory = JournalCategory.gleanings;
      });
      GoRouter.of(context).pop();
    } catch (e) {
      showMessage('Failed to upload article: $e', context);
    }
  }

  // chip categories
  Widget _buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Journal Category:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10.0,
              children: JournalCategory.values.map((category) {
                return ChoiceChip(
                  label: Text(category.toTitle()),
                  selected: _selectedCategory == category,
                  selectedColor: theme.colorScheme.primary.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _selectedCategory == category
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: _selectedCategory == category
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: const Text(
          'Write Journal Article',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            fontFamily: 'Playfair',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Cover Image Upload ---
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _coverImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.image,
                                  size: 40, color: theme.colorScheme.primary),
                              const SizedBox(height: 8),
                              const Text('Tap to select cover image'),
                            ],
                          )
                        : Text(_coverImage!.name),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 2. Category Selection Chips ---
              _buildCategoryChips(context),
              const SizedBox(height: 20),

              // --- 3. Text Fields ---
              CustomTextInput(
                controller: _titleController,
                isIcon: false,
                label: 'Article Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              CustomTextInput(
                controller: _authorController,
                isIcon: false,
                label: 'Author Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Author name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              CustomTextInput(
                controller: _articleController,
                label: 'Journal Writeup (Article Content)',
                maxLine: 25,
                isIcon: false,
                isMultiline: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Article content is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // --- 4. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _uploadJournalPost, // Renamed function
                  icon: const Icon(Iconsax.send_sqaure_2, color: Colors.white),
                  label: Text(
                    'Upload Article',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
