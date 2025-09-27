/// Defines the fixed categories for the journal posts.
enum JournalCategory {
  gleanings,
  review,
  moreThanRubies,
  dearDisciples,
  practicalDiscipleship,
  livingReady,
}

/// Utility extension to easily convert the enum to a human-readable string and back.
extension JournalCategoryExtension on JournalCategory {
  String toTitle() {
    // Converts 'moreThanRubies' to 'More Than Rubies'
    return name.replaceAllMapped(
      RegExp(r'([A-Z])'), 
      (match) => '_${match.group(1)!.toLowerCase()}'
    ).split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}

// --- COMMENT MODEL ---

/// Model for individual user comments on a journal post.
class JournalComment {
  final String personName;
  final DateTime date;
  final String personComment;

  JournalComment({
    required this.personName,
    required this.date,
    required this.personComment,
  });

  factory JournalComment.fromJson(Map<String, dynamic> json) {
    return JournalComment(
      personName: json['person_name'] as String? ?? 'Unknown User',
      // Parses ISO 8601 string from JSON. Handles potential nulls gracefully.
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(), 
      personComment: json['person_comment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_name': personName,
      'date': date.toIso8601String(), 
      'person_comment': personComment,
    };
  }
}

// --- JOURNAL POST MODEL ---

/// Model for the main journal post content.
class JournalPost {
  final String? id; 
  final String title;
  final String authorName;
  final String imageUrl;
  final DateTime date;
  final JournalCategory category; // Now using the type-safe enum
  final String journalWriteup;
  final List<JournalComment> comments;

  JournalPost({
    this.id,
    required this.title,
    required this.authorName,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.journalWriteup,
    this.comments = const [],
  });

  factory JournalPost.fromJson(Map<String, dynamic> json, {String? docId}) {
    List<JournalComment> parsedComments = [];
    if (json['comments'] is List) {
      parsedComments = (json['comments'] as List)
          .map((i) => JournalComment.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    
    // Safely parse the category string into the enum value.
    JournalCategory postCategory;
    try {
      // Assuming JSON stores category as a snake_case or camelCase string (e.g., 'practical_discipleship')
      final categoryString = (json['category'] as String?)?.toLowerCase().replaceAll('_', '');
      postCategory = JournalCategory.values.firstWhere(
        (e) => e.name.toLowerCase().replaceAll('_', '') == categoryString,
        orElse: () => JournalCategory.gleanings, // Default if category is unrecognized
      );
    } catch (e) {
      postCategory = JournalCategory.gleanings; 
    }

    return JournalPost(
      id: docId,
      title: json['title'] as String? ?? 'Untitled Post',
      authorName: json['author_name'] as String? ?? 'Anonymous',
      imageUrl: json['image'] as String? ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      category: postCategory,
      journalWriteup: json['journal_writeup'] as String? ?? '',
      comments: parsedComments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author_name': authorName,
      'image': imageUrl,
      'date': date.toIso8601String(),
      'category': category.name, // Stores the enum name as a string (e.g., 'practicalDiscipleship')
      'journal_writeup': journalWriteup,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
