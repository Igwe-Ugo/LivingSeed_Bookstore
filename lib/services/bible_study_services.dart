// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/models/widget.dart';
import 'package:path_provider/path_provider.dart';

class BibleStudyProvider extends ChangeNotifier {
  BibleStudyMaterial? _currentBibleStudy;
  BibleStudyMaterial? get bibleStudyData => _currentBibleStudy;

  List<BibleStudyMaterial> _bibleStudies = [];
  List<BibleStudyMaterial> get allBibleStudies => _bibleStudies;

  Future<List<BibleStudyMaterial>>? bibleStudyFuture; // Cached future for reuse

  // Initialize books once when the app starts
  Future<void> initializeBibleStudy() async {
    bibleStudyFuture = _loadBibleStudy(); // Store future so it can be reused
    notifyListeners();
  }

  // Fetch books from both assets and local storage
  Future<List<BibleStudyMaterial>> _loadBibleStudy() async {
    List<BibleStudyMaterial> assetBibleStudy =
        await _loadBibleStudyFromAssets();
    List<BibleStudyMaterial> localBibleStudy = await _loadBibleStudyFromLocal();

    // Merge books while preventing duplicates
    Set<String> existingTitles =
        localBibleStudy.map((bibleStudy) => bibleStudy.title).toSet();
    assetBibleStudy
        .removeWhere((bibleStudy) => existingTitles.contains(bibleStudy.title));

    _bibleStudies = [
      ...localBibleStudy,
      ...assetBibleStudy
    ]; // Prioritize local books
    return _bibleStudies;
  }

  // Fetch books from assets (JSON)
  Future<List<BibleStudyMaterial>> _loadBibleStudyFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/biblestudy.json');
      List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => BibleStudyMaterial.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error Loading JSON: $e');
      return [];
    }
  }

  // Fetch books from local storage (if available)
  Future<List<BibleStudyMaterial>> _loadBibleStudyFromLocal() async {
    try {
      final file = await _getBibleStudyFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList
            .map((json) => BibleStudyMaterial.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading local bible study data: $e');
    }
    return [];
  }

  // Get file location for local book storage
  Future<File> _getBibleStudyFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/biblestudy.json');
  }

  // Save books to local storage
  Future<void> _saveBibleStudyToLocal() async {
    try {
      final file = await _getBibleStudyFile();
      String jsonData =
          json.encode(_bibleStudies.map((book) => book.toJson()).toList());
      await file.writeAsString(jsonData, mode: FileMode.write);
    } catch (e) {
      debugPrint('Error saving book data: $e');
    }
  }

  // Upload book and update local storage
  Future<bool> uploadBibleStudy(BibleStudyMaterial newBook) async {
    if (_bibleStudies.any((book) => book.title == newBook.title)) {
      return false; // Prevent duplicates
    }
    _bibleStudies.add(newBook);
    _currentBibleStudy = newBook;
    await _saveBibleStudyToLocal();
    notifyListeners();
    return true;
  }

  void deleteBiblestudy(String title) {
    if (_bibleStudies != null) {
      _bibleStudies.removeWhere((item) => item.title == title);
      _saveBibleStudyToLocal();
      notifyListeners();
    }
  }
}
