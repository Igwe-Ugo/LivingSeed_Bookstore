import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class WriteArticle extends StatefulWidget {
  const WriteArticle({super.key});

  @override
  State<WriteArticle> createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();
  DateTime articleDate = DateTime.now();
  String? selectedArticleCategory;
  JournalCategory _selectedCategory = JournalCategory.gleanings;

  void setSelectedArticleCategory(String? value) {
    setState(() => selectedArticleCategory = value);
    debugPrint(value);
  }

  // --- File Handling State ---
  XFile? _coverImage;

  void _uploadBookToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    // Validate file paths
    if (_coverImage == null) {
      return showMessage('Please select a cover image', context);
    }

    JournalPost newArticle = JournalPost(
        title: _titleController.text,
        authorName: _authorController.text,
        imageUrl: _coverImage!.path.isNotEmpty
            ? _coverImage!.path
            : _coverImage!.name,
        date: articleDate,
        category: _selectedCategory,
        journalWriteup: _articleController.text,
        comments: []);

    await Provider.of<JournalProvider>(context).addJournalPost(newArticle);

    showMessage('Article uploaded successfully!', context);
    GoRouter.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _articleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: const Text(
          'Upload New Article',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. File Uploads (Cover Image & PDF) ---
              // Cover Image Picker: USING THE REUSABLE WIDGET
              ImagePickerDropZone(
                title: 'Upload Article Cover (Image)',
                icon: Iconsax.image,
                color: Colors.green,
                // The callback updates the state in the parent screen
                onFilePicked: (file) {
                  setState(() {
                    _coverImage = file;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Which category should this article belong to? Select one below:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
              ),
              _buildCategoryChips(context),
              const SizedBox(
                height: 20,
              ),
              // --- 2. Text Inputs ---
              CustomTextInput(
                label: 'Message title...',
                controller: _titleController,
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a title for this article';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: 'Author Name...',
                controller: _authorController,
                icon: Iconsax.user_tag,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add the name of the author for this article';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: "Article Write Up...",
                controller: _articleController,
                isIcon: false,
                maxLine: 10,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a write up for this article';
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
                  onPressed: _uploadBookToJson,
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

  // chip categories
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
}
