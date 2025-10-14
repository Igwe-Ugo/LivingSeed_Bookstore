// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/models/widget.dart';
import 'package:path_provider/path_provider.dart';
import "package:uuid/uuid.dart";

class UsersAuthProvider extends ChangeNotifier {
  Users? _currentUser;
  Users? get userData => _currentUser;
  List<Users> _users = [];
  List<Users> get allUsers => _users;
  bool _isInitialized = false;
  // uuid generator instance
  final Uuid _uuid = const Uuid();

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

  /// Registers the user locally (as unverified) and simulates sending an OTP.
  /// Returns user details and the temporary code for the next step.
  Future<Map<String, dynamic>> signUp({
    required Users newUser,
  }) async {
    try {
      if (_users.any((user) => user.emailAddress == newUser.emailAddress)) {
        return {
          'success': false,
          'error': 'User with this email already exists.'
        };
      }

      // Create the new user object and add to list
      final createdUser = Users(
        fullname: newUser.fullname,
        emailAddress: newUser.emailAddress,
        password: newUser.password,
        telephone: newUser.telephone,
        gender: newUser.gender,
        userImage: 'assets/images/avatar.png',
        dateOfBirth: '',
        role: 'Regular',
        cart: [],
        bookPurchased: [],
        transactionHistory: [],
      );

      _users.add(createdUser);
      // Do something to send OTP here in a real app
      // For simulation, we skip actual sending and just return success
      //await _saveUserToLocal();
      //notifyListeners();

      return {
        'success': true,
        'fullname': newUser.fullname, // Return fullName for display
        'email': newUser.emailAddress,
      };
    } catch (e) {
      debugPrint('Sign Up Error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred during sign up.'
      };
    }
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

  void _addActivityLog(String title, String subtitle, String relatedBookId) {
    // check 1: must be a current user
    if (_currentUser == null) return;
    // check 2: must be admin to log activity
    if (_currentUser!.role != 'Admin') {
      debugPrint('Attempted to log activity but user is not an Admin');
      return;
    }

    final newActivity = AdminRecentActivity(
        id: _uuid.v4(),
        title: title,
        subtitle: subtitle,
        timestamp: DateTime.now(),
        relatedBookId: relatedBookId);
    // add the new activity to the start of the list
    _currentUser!.recentActivities!.insert(0, newActivity);
    // optional: limit the number of activities
    if (_currentUser!.recentActivities!.length > 20) {
      _currentUser!.recentActivities!.removeLast();
    }
    notifyListeners();
    _saveUserToLocal();
  }

  // dummy book management (needs integration with actual book provider)
  // called after a book is successfully edited
  void logBookUploaded(AboutBooks book) {
    _addActivityLog('Book Uploaded', book.bookTitle, book.bookId);
  }

  /// Called after a book is successfully edited.
  void logBookEdited(AboutBooks book) {
    _addActivityLog(
      'Book Edited',
      book.bookTitle,
      book.bookId,
    );
  }

  /// Called after a book is successfully deleted.
  void logBookDeleted(String bookTitle, String bookId) {
    _addActivityLog(
      'Book Deleted',
      bookTitle,
      bookId,
    );
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

  void addToMagazineCart(MagazineModel magazine) {
    if (_currentUser != null) {
      _currentUser!.cart.add(CartItems(
          coverImage: magazine.coverImage,
          bookTitle: magazine.magazineTitle,
          bookAuthor: magazine.publisher,
          amount: magazine.price));
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
