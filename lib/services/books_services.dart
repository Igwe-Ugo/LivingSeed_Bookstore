// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/models/widget.dart';
import 'package:path_provider/path_provider.dart';

class BookProvider extends ChangeNotifier {
  AboutBooks? _currentBook;
  AboutBooks? get bookData => _currentBook;

  List<AboutBooks> _books = [];
  List<AboutBooks> get allBooks => _books;

  Future<List<AboutBooks>>? booksFuture; // Cached future for reuse

  // Initialize books once when the app starts
  Future<void> initializeBooks() async {
    booksFuture = _loadBooks(); // Store future so it can be reused
    notifyListeners();
  }

  // Fetch books from both assets and local storage
  Future<List<AboutBooks>> _loadBooks() async {
    List<AboutBooks> assetBooks = await _loadBooksFromAssets();
    List<AboutBooks> localBooks = await _loadBooksFromLocal();

    // Merge books while preventing duplicates
    Set<String> existingTitles =
        localBooks.map((book) => book.bookTitle).toSet();
    assetBooks.removeWhere((book) => existingTitles.contains(book.bookTitle));

    _books = [...localBooks, ...assetBooks]; // Prioritize local books
    return _books;
  }

  // Fetch books from assets (JSON)
  Future<List<AboutBooks>> _loadBooksFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/about_book.json');
      List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => AboutBooks.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error Loading JSON: $e');
      return [];
    }
  }

  // Fetch books from local storage (if available)
  Future<List<AboutBooks>> _loadBooksFromLocal() async {
    try {
      final file = await _getBooksFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList.map((json) => AboutBooks.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local book data: $e');
    }
    return [];
  }

  // Get file location for local book storage
  Future<File> _getBooksFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/about_book.json');
  }

  // Save books to local storage
  Future<void> _saveBooksToLocal() async {
    try {
      final file = await _getBooksFile();
      String jsonData =
          json.encode(_books.map((book) => book.toJson()).toList());
      await file.writeAsString(jsonData, mode: FileMode.write);
    } catch (e) {
      debugPrint('Error saving book data: $e');
    }
  }

  // Upload book and update local storage
  Future<bool> uploadBook(AboutBooks newBook) async {
    if (_books.any((book) => book.bookTitle == newBook.bookTitle)) {
      return false; // Prevent duplicates
    }
    _books.add(newBook);
    _currentBook = newBook;
    await _saveBooksToLocal();
    notifyListeners();
    return true;
  }

  // updates an existing book in the local list and save the changes.
  Future<void> updateBook(AboutBooks updatedBook) async {
    final index = _books.indexWhere((book) => book.bookId == updatedBook.bookId);
    if (index != -1){
      _books[index] = updatedBook;
      await _saveBooksToLocal();
      notifyListeners();
      debugPrint('Success: Book with ID ${updatedBook.bookId} updated successfully.');
    } else {
      debugPrint('Error: Book with ID ${updatedBook.bookId} not found for update.');
    }
  }
}
