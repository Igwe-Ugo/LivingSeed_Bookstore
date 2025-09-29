import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_media/common/widget.dart';

class PdfFilePickerDropZone extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  // Callback function to send the picked PlatformFile back to the parent widget
  final Function(PlatformFile?) onFilePicked;
  final String? initialFileName;

  const PdfFilePickerDropZone({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onFilePicked,
    this.initialFileName,
  });

  @override
  State<PdfFilePickerDropZone> createState() => _PdfFilePickerDropZoneState();
}

class _PdfFilePickerDropZoneState extends State<PdfFilePickerDropZone> {
  // Encapsulated State: The file state lives inside this reusable widget
  PlatformFile? _pickedFile;

  // Encapsulated Logic: The PDF picking logic as requested
  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      // Check if a file was successfully picked and has a path
      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        setState(() {
          _pickedFile = file;
          // Notify the parent component of the new file
          widget.onFilePicked(_pickedFile);
        });
      }
    } catch (e) {
      debugPrint('Failed to pick PDF file: $e');
      showMessage('Failed to pick PDF file. Check permissions.', context);
    }
  }

  // Reusable UI: The drop zone look and feel
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine the name of the selected file for display
    final fileName = _pickedFile?.path ?? _pickedFile?.name;

    return GestureDetector(
      onTap: _pickPdf, // Calls the internal picking logic
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
              'Tap to select PDF file',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
