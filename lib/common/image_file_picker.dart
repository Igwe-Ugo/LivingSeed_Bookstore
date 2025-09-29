import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/show_message.dart';

class ImagePickerDropZone extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  // Callback function to send the picked file back to the parent widget
  final Function(XFile?) onFilePicked;

  const ImagePickerDropZone({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onFilePicked,
  });

  @override
  State<ImagePickerDropZone> createState() => _ImagePickerDropZoneState();
}

class _ImagePickerDropZoneState extends State<ImagePickerDropZone> {
  // 1. Encapsulated State: The file state lives inside this reusable widget
  XFile? _pickedFile;

  // 2. Encapsulated Logic: The file picking logic lives inside this widget
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _pickedFile = image;
          // Notify the parent component of the new file
          widget.onFilePicked(_pickedFile);
        });
      }
    } catch (e) {
      debugPrint('Failed to pick image: $e');
      showMessage('Failed to pick image.', context);
    }
  }

  // 3. Reusable UI: The drop zone look and feel
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine the name of the selected file for display
    final fileName = _pickedFile?.path.isNotEmpty == true ? _pickedFile!.path : _pickedFile?.name;

    return GestureDetector(
      onTap: _pickImage, // Calls the internal picking logic
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _pickedFile != null ? widget.color : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon,
                size: 40,
                color: _pickedFile != null ? widget.color : theme.disabledColor),
            const SizedBox(height: 8),
            Text(
              _pickedFile != null
                  ? 'Selected: ${fileName?.split('/').last}' // Show only the filename
                  : widget.title,
              style: TextStyle(
                color: _pickedFile != null ? widget.color : theme.textTheme.bodyLarge?.color,
                fontWeight: _pickedFile != null ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Tap or Drag & Drop (Desktop)',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
