import 'dart:convert';

class RatingReview {
  final String reviewText;
  final String reviewTitle;
  final String date;
  final String reviewer;
  final double reviewRating;

  RatingReview(
      {required this.reviewText,
      required this.reviewTitle,
      required this.date,
      required this.reviewer,
      required this.reviewRating});

  // Convert JSON to RatingReview object
  factory RatingReview.fromJson(Map<String, dynamic> json) {
    return RatingReview(
      reviewText: json["reviewText"],
      date: json["date"],
      reviewTitle: json["reviewTitle"],
      reviewer: json["reviewer"],
      reviewRating: (json["reviewRating"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reviewText": reviewText,
      "date": date,
      "reviewTitle": reviewTitle,
      "reviewer": reviewer,
      "reviewRating": reviewRating,
    };
  }
}

class AboutBooks {
  final String coverImage;
  final String bookTitle;
  final String author;
  final double amount;
  final String aboutAuthor;
  final String aboutBook;
  final int chapterNum;
  final String pdfLink;
  final List<Map<String, String>> chapters;
  final List<RatingReview> ratingReviews;

  AboutBooks(
      {required this.coverImage,
      required this.bookTitle,
      required this.author,
      required this.amount,
      required this.aboutAuthor,
      required this.aboutBook,
      required this.chapterNum,
      required this.pdfLink,
      required this.chapters,
      required this.ratingReviews});

  factory AboutBooks.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> extractedChapters = [];
    if (json['chapters'] != null && json['chapters'] is List) {
      extractedChapters = (json['chapters'] as List)
          .map((chapter) => Map<String, String>.from(chapter as Map))
          .toList();
    }

    List<RatingReview> extractedReviews = [];
    if (json['ratingReviews'] != null && json['ratingReviews'] is List) {
      extractedReviews = (json['ratingReviews'] as List)
          .map((item) => RatingReview.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return AboutBooks(
        coverImage: json['coverImage'],
        bookTitle: json['bookTitle'],
        author: json['author'],
        amount: (json['amount'] as num).toDouble(),
        aboutAuthor: json['aboutAuthor'],
        aboutBook: json['aboutBook'],
        chapterNum: json['chapterNum'],
        pdfLink: json['pdfLink'],
        chapters: extractedChapters,
        ratingReviews: extractedReviews);
  }

  Map<String, dynamic> toJson() {
    return {
      "coverImage": coverImage,
      "bookTitle": bookTitle,
      "author": author,
      "amount": amount,
      "aboutAuthor": aboutAuthor,
      "aboutBook": aboutBook,
      "chapterNum": chapterNum,
      "pdfLink": pdfLink,
      "chapters": chapters,
      "ratingReviews": ratingReviews.map((review) => review.toJson()).toList(),
    };
  }

  static List<AboutBooks> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => AboutBooks.fromJson(item)).toList();
  }
}
