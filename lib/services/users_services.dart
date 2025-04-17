// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:path_provider/path_provider.dart';

class UsersAuthProvider extends ChangeNotifier {
  Users? _currentUser;
  Users? get userData => _currentUser;
  List<Users> _users = [];
  List<Users> get allUsers => _users;
  bool _isInitialized = false;

  Future<void> initializeUsers() async {
    if (_isInitialized) return;
    String jsonString = await rootBundle.loadString('assets/json/users.json');
    _users = Users.fromJsonList(jsonString);
    await _loadUserFromLocal();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadUserFromLocal() async {
    try {
      final file = await _getUserFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        _users = jsonList.map((json) => Users.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local user data: $e');
    }
  }

  Future<File> _getUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<void> _saveUserToLocal() async {
    final file = await _getUserFile();
    String jsonData = json.encode(_users.map((user) => user.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  Future<Users?> signIn(String email, String password) async {
    if (_users.isEmpty) {
      await initializeUsers(); // Ensure users are loaded before checking
    }

    Users? user = _users.firstWhereOrNull(
      (u) => u.emailAddress == email && u.password == password,
    );

    if (user != null) {
      debugPrint('User found and logged in: ${user.emailAddress}');
      _currentUser = user;
      notifyListeners();
      return _currentUser;
    } else {
      debugPrint("Error: Invalid credentials for $email");
      return null;
    }
  }

  Future<bool> signup(Users newUser) async {
    if (_users.any((user) => user.emailAddress == newUser.emailAddress)) {
      return false; // Email Already exists
    }
    _users.add(newUser);
    _currentUser = newUser;
    await _saveUserToLocal();
    notifyListeners();
    return true;
  }

  Future<bool> changePassword(String newPassword, String oldPassword) async {
    Users? user = _users.firstWhereOrNull((u) => u.password == oldPassword);
    if (user != null && user.password == oldPassword) {
      user.password = newPassword;
      await _saveUserToLocal();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void signout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> changeEmail(String emailAddress) async {
    Users? userEmail =
        _users.firstWhereOrNull((u) => u.emailAddress == emailAddress);
    if (userEmail != null) {
      userEmail.emailAddress = emailAddress;
      await _saveUserToLocal();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeFullname(String fullname) async {
    Users? userFullname =
        _users.firstWhereOrNull((u) => u.fullname == fullname);
    if (userFullname != null) {
      userFullname.emailAddress = fullname;
      await _saveUserToLocal();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeDateOfBirth(String dateOfBirth) async {
    Users? userDateOfBirth =
        _users.firstWhereOrNull((u) => u.dateOfBirth == dateOfBirth);
    if (userDateOfBirth != null) {
      userDateOfBirth.dateOfBirth = dateOfBirth;
      await _saveUserToLocal();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void deleteUser(String fullname) {
    if (_users != null) {
      _users.removeWhere((item) => item.fullname == fullname);
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void updateUserInfo(Users updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
    _saveUserToLocal();
  }

  void addToBookCart(AboutBooks book) {
    if (_currentUser != null) {
      _currentUser!.cart.add(CartItems(
          coverImage: book.coverImage,
          bookTitle: book.bookTitle,
          bookAuthor: book.author,
          amount: book.amount));
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void addToBibleStudyCart(BibleStudyMaterial book) {
    if (_currentUser != null) {
      _currentUser!.cart.add(CartItems(
          coverImage: book.coverImage,
          bookTitle: book.title,
          bookAuthor: book.subTitle,
          amount: book.amount));
      notifyListeners();
      _saveUserToLocal();
    }
  }

  // remove specific item from cart
  void removeFromCart(String bookTitle) {
    if (_currentUser != null) {
      _currentUser!.cart.removeWhere((item) => item.bookTitle == bookTitle);
      notifyListeners();
      _saveUserToLocal();
    }
  }

  // clear the entire cart
  void clearCart() {
    if (_currentUser != null) {
      _currentUser!.cart.clear();
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void makeAdmin(String email) {
    Users? user = _users.firstWhereOrNull((u) => u.emailAddress == email);
    if (user != null) {
      user.role = 'Admin';
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void removeAdmin(String email) {
    Users? user = _users.firstWhereOrNull((u) => u.emailAddress == email);
    if (user != null) {
      user.role = 'Regular';
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void addToBookPurchase(AboutBooks book) {
    if (_currentUser != null) {
      _currentUser!.bookPurchased.add(PurchasedBooksItems(
        bookTitle: book.bookTitle,
        coverImage: book.coverImage,
        bookAuthor: book.author,
        readBookPath: book.pdfLink,
      ));
      clearCart();
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void deletePurchasedBook(String bookTitle) {
    if (_currentUser != null) {
      _currentUser!.bookPurchased
          .removeWhere((item) => item.bookTitle == bookTitle);
      notifyListeners();
      _saveUserToLocal();
    }
  }
}
