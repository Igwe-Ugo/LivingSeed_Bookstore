import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:path_provider/path_provider.dart';

class MagazineProvider extends ChangeNotifier {
  List<MagazineModel> _magazines = [];
  List<MagazineModel> get magazines => _magazines;
  Future<List<MagazineModel>>? magazineFuture; // Cached future for reuse

  Future<void> initializeMagazines() async {
    magazineFuture = _loadMagazines();
    notifyListeners();
  }

  Future<List<MagazineModel>> _loadMagazines() async {
    try {
      List<MagazineModel> assetMagazines = await _loadMagazinesFromAssets();
      List<MagazineModel> localMagazines = await _loadMagazinesFromLocal();
      Set<String> existingTitles =
          localMagazines.map((mag) => mag.magazineTitle).toSet();
      assetMagazines
          .removeWhere((mag) => existingTitles.contains(mag.magazineTitle));
      _magazines = [...localMagazines, ...assetMagazines];
      return _magazines;
    } catch (e) {
      debugPrint('Error loading magazines: $e');
      return [];
    }
  }

  Future<List<MagazineModel>> _loadMagazinesFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/magazines.json');
      List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => MagazineModel.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading magazines from assets: $e');
      return [];
    }
  }

  Future<List<MagazineModel>> _loadMagazinesFromLocal() async {
    try {
      final file = await _getMagazineFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList.map((json) => MagazineModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading magazines from Local: $e');
    }
    return [];
  }

  Future<File> _getMagazineFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/magazines.json');
  }

  /* Future<void> _saveMagazinesToLocal() async {
    try {
      final file = await _getMagazineFile();
      String jsonData =
          json.encode(_magazines.map((mag) => mag.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving magazines: $e');
    }
  } */
}
