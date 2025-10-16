import 'dart:convert';

class CartItems {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;
  final double amount;

  CartItems({
    required this.bookTitle,
    required this.coverImage,
    required this.bookAuthor,
    required this.amount,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      bookTitle: json['bookTitle'],
      coverImage: json['coverImage'],
      bookAuthor: json['bookAuthor'],
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookTitle': bookTitle,
      'coverImage': coverImage,
      'bookAuthor': bookAuthor,
      'amount': amount,
    };
  }
}

class PurchasedBooksItems {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;
  final String readBookPath;

  PurchasedBooksItems({
    required this.bookTitle,
    required this.coverImage,
    required this.bookAuthor,
    required this.readBookPath,
  });

  factory PurchasedBooksItems.fromJson(Map<String, dynamic> json) {
    return PurchasedBooksItems(
      bookTitle: json["bookTitle"],
      bookAuthor: json["bookAuthor"],
      coverImage: json["coverImage"],
      readBookPath: json['readBookPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookTitle': bookTitle,
      'coverImage': coverImage,
      'bookAuthor': bookAuthor,
      'readBookPath': readBookPath,
    };
  }
}

class TransactionDescription {
  final String bookName;
  final double unitCost;
  final int quantity;
  final double totalCost;

  TransactionDescription(
      {required this.bookName,
      required this.unitCost,
      required this.quantity,
      required this.totalCost});

  factory TransactionDescription.fromJson(Map<String, dynamic> json) {
    return TransactionDescription(
        bookName: json['bookName'],
        unitCost: (json['unitCost'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
        totalCost: (json['totalCost'] as num).toDouble());
  }

  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'unitCost': unitCost,
      'quantity': quantity,
      'totalCost': totalCost
    };
  }
}

class TransactionHistory {
  final int receiptNo;
  final String transactionDate;
  final String transactionTime;
  final String transactionTitle;
  final List<TransactionDescription> description;

  TransactionHistory(
      {required this.receiptNo,
      required this.transactionTitle,
      required this.transactionDate,
      required this.transactionTime,
      required this.description});

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    List<TransactionDescription> extractedDescriptions = [];
    if (json['description'] != null && json['description'] is List) {
      extractedDescriptions = (json['description'] as List)
          .map(
              (e) => TransactionDescription.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return TransactionHistory(
        transactionTitle: json['transactionTitle'],
        receiptNo: (json['receiptNo'] as num).toInt(),
        transactionDate: json['transactionDate'],
        transactionTime: json['transactionTime'],
        description: extractedDescriptions);
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionTitle': transactionTitle,
      'receiptNo': receiptNo,
      'transactionDate': transactionDate,
      'transactionTime': transactionTime,
      'description': description.map((e) => e.toJson()).toList()
    };
  }
}

class Users {
  final String fullname;
  String emailAddress;
  final String telephone;
  final String userImage;
  String password;
  final String gender;
  String dateOfBirth;
  String role;
  final List<CartItems> cart;
  final List<PurchasedBooksItems> bookPurchased;
  final List<TransactionHistory> transactionHistory;

  Users({
    required this.fullname,
    required this.emailAddress,
    required this.userImage,
    required this.telephone,
    required this.password,
    required this.gender,
    required this.dateOfBirth,
    required this.role,
    required this.cart,
    required this.bookPurchased,
    required this.transactionHistory,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    List<CartItems> extractedCart = [];
    if (json['cart'] != null && json['cart'] is List) {
      extractedCart = (json['cart'] as List)
          .map((e) => CartItems.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<PurchasedBooksItems> extractedBookPurchased = [];
    if (json['bookPurchased'] != null && json['bookPurchased'] is List) {
      extractedBookPurchased = (json['bookPurchased'] as List)
          .map((e) => PurchasedBooksItems.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<TransactionHistory> extractedTransactionHistory = [];
    if (json['transactionHistory'] != null &&
        json['transactionHistory'] is List) {
      extractedTransactionHistory = (json['transactionHistory'] as List)
          .map((e) => TransactionHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Users(
        fullname: json['fullname'],
        emailAddress: json['emailAddress'],
        userImage: json['userImage'],
        telephone: json['telephone'],
        password: json['password'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        role: json['role'],
        cart: extractedCart,
        bookPurchased: extractedBookPurchased,
        transactionHistory: extractedTransactionHistory,
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'emailAddress': emailAddress,
      'userImage': userImage,
      'telephone': telephone,
      'password': password,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'role': role,
      'cart': cart.map((e) => e.toJson()).toList(),
      'bookPurchased': bookPurchased.map((e) => e.toJson()).toList(),
      'transactionHistory': transactionHistory.map((e) => e.toJson()).toList(),
    };
  }

  // Convert a JSON string (list) to a list of Users
  static List<Users> fromJsonList(String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString); // Ensure it's a list
    return jsonList.map((json) => Users.fromJson(json)).toList();
  }
}
