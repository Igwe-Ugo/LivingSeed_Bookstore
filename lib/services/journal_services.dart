// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/journal_model.dart'; // Import the model file

/// Service class responsible for managing journal data (fetching, adding, persisting).
class JournalProvider extends ChangeNotifier {
  List<JournalPost> _posts = [];
  List<JournalPost> get allPosts => _posts;

  Future<List<JournalPost>>? postsFuture; // Cached future for reuse

  // --- Initialization and Loading ---

  /// Initializes posts once when the app starts.
  Future<void> initializeJournalPosts() async {
    postsFuture = _loadJournalPosts(); // Store future so it can be reused
    notifyListeners();
  }

  /// Determines the file location for local journal storage.
  Future<File> _getJournalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/living_journal_posts.json');
  }

  /// Fetches posts from local storage (highest priority).
  Future<List<JournalPost>> _loadPostsFromLocal() async {
    try {
      final file = await _getJournalFile();
      if (await file.exists()) {
        final data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList.map((json) => JournalPost.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local journal data: $e');
    }
    return [];
  }

  /// Fetches posts from assets (initial data).
  Future<List<JournalPost>> _loadPostsFromAssets() async {
    const String _jsonAssetPath = 'assets/json/living_journal_posts.json';
    try {
      final String jsonString = await rootBundle.loadString(_jsonAssetPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => JournalPost.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error Loading Journal JSON from assets: $e');
      return [];
    }
  }

  /// Main loading function: prioritizes local storage over asset defaults.
  Future<List<JournalPost>> _loadJournalPosts() async {
    List<JournalPost> localPosts = await _loadPostsFromLocal();
    List<JournalPost> assetPosts = await _loadPostsFromAssets();

    // Only load assets if local storage is empty.
    if (localPosts.isNotEmpty) {
      _posts = localPosts;
    } else {
      _posts = assetPosts;
    }
    
    // Ensure all posts have unique IDs (important for adding new ones dynamically)
    // For simplicity, we just assign index-based IDs if null
    _posts = _posts.map((post) {
      if (post.id == null) {
        return JournalPost(
          id: UniqueKey().toString(), // Assign a unique key as ID
          title: post.title,
          authorName: post.authorName,
          imageUrl: post.imageUrl,
          date: post.date,
          category: post.category,
          journalWriteup: post.journalWriteup,
          comments: post.comments,
        );
      }
      return post;
    }).toList();


    return _posts;
  }

  // --- Data Persistence ---

  /// Saves the current list of journal posts to local storage.
  Future<void> _savePostsToLocal() async {
    try {
      final file = await _getJournalFile();
      final jsonData =
          json.encode(_posts.map((post) => post.toJson()).toList());
      await file.writeAsString(jsonData, mode: FileMode.write);
    } catch (e) {
      debugPrint('Error saving journal data: $e');
    }
  }

  // --- Dynamic Updates ---

  /// Adds a new journal post to the list and persists the data.
  Future<void> addJournalPost(JournalPost newPost) async {
    // 1. Assign a unique ID if one wasn't provided (Crucial for later updates/deletion)
    final postWithId = JournalPost(
      id: UniqueKey().toString(),
      title: newPost.title,
      authorName: newPost.authorName,
      imageUrl: newPost.imageUrl,
      date: newPost.date,
      category: newPost.category,
      journalWriteup: newPost.journalWriteup,
      comments: newPost.comments,
    );

    // 2. Insert the new post at the beginning (making it the "latest")
    _posts.insert(0, postWithId);

    // 3. Persist the change
    await _savePostsToLocal();

    // 4. Notify listeners to update the UI
    notifyListeners();
  }

  // --- Filtering (Optional but useful) ---

  List<JournalPost> getPostsByCategory(JournalCategory category) {
    return _posts.where((post) => post.category == category).toList();
  }

  /// Adds a new top-level comment to a specific journal post.
  Future<void> addCommentToPost(String postId, JournalComment comment) async {
    int index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      // Create a new list for comments to ensure proper immutability/change detection
      List<JournalComment> updatedComments = List.from(_posts[index].comments);
      updatedComments.add(comment);
      
      // Create a new post object with updated comments list
      _posts[index] = JournalPost(
        id: _posts[index].id,
        title: _posts[index].title,
        authorName: _posts[index].authorName,
        imageUrl: _posts[index].imageUrl,
        date: _posts[index].date,
        category: _posts[index].category,
        journalWriteup: _posts[index].journalWriteup,
        comments: updatedComments,
      );
      
      await _savePostsToLocal();
      notifyListeners();
    }
  }

  /// Adds a reply to an existing comment within a specific journal post.
  Future<void> replyCommentOnPost(String postId, int commentIndex, JournalReplyComment reply) async {
    int postIdx = _posts.indexWhere((post) => post.id == postId);
    
    if (postIdx != -1 && commentIndex >= 0 && commentIndex < _posts[postIdx].comments.length) {
      // Reference the original comment
      JournalComment originalComment = _posts[postIdx].comments[commentIndex];
      
      // Create a new list of replies, adding the new reply
      List<JournalReplyComment> updatedReplies = List.from(originalComment.replies)..add(reply);

      // Create a new comment object with the updated replies list
      JournalComment updatedComment = JournalComment(
        personName: originalComment.personName,
        date: originalComment.date,
        personComment: originalComment.personComment,
        replies: updatedReplies,
      );

      // Create a new list of comments for the post
      List<JournalComment> updatedComments = List.from(_posts[postIdx].comments);
      
      // Replace the old comment with the updated comment
      updatedComments[commentIndex] = updatedComment;
      
      // Create a new post object with the updated comments list
      _posts[postIdx] = JournalPost(
        id: _posts[postIdx].id,
        title: _posts[postIdx].title,
        authorName: _posts[postIdx].authorName,
        imageUrl: _posts[postIdx].imageUrl,
        date: _posts[postIdx].date,
        category: _posts[postIdx].category,
        journalWriteup: _posts[postIdx].journalWriteup,
        comments: updatedComments,
      );
      
      await _savePostsToLocal();
      notifyListeners();
    } else {
      debugPrint('Error: Post ID ($postId) or Comment Index ($commentIndex) not found.');
    }
  }

  Future<void> updateJournal(JournalPost updatedPost) async {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
      await _savePostsToLocal();
      notifyListeners();
      debugPrint('Success: Journal with ID ${updatedPost.id} updated successfully.');
    } else {
      debugPrint('Error: Journal with ID ${updatedPost.id} not found for update.');
    }
  }

}
