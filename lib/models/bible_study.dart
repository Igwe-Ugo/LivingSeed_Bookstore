import 'dart:convert';

class Chapter {
  final int chapterNum;
  final String chapterTitle;

  Chapter({
    required this.chapterNum,
    required this.chapterTitle,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNum: json['chapterNum'],
      chapterTitle: json['chapterTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterNum': chapterNum,
      'chapterTitle': chapterTitle,
    };
  }
}

class BibleStudyMaterial {
  final String bibleStudyId;
  final String title;
  final double amount;
  final String subTitle;
  final String coverImage;
  final String pdfLink;
  final int chapterNum;
  final List<Chapter> contents;

  BibleStudyMaterial(
      {required this.title,
      required this.bibleStudyId,
      required this.chapterNum,
      required this.amount,
      required this.coverImage,
      required this.pdfLink,
      required this.contents,
      required this.subTitle});

  factory BibleStudyMaterial.fromJson(Map<String, dynamic> json) {
    return BibleStudyMaterial(
        bibleStudyId: json['bibleStudyId'],
        subTitle: json['subTitle'],
        coverImage: json['coverImage'],
        title: json['title'],
        chapterNum: json['chapterNum'],
        amount: (json['amount'] as num).toDouble(),
        pdfLink: json['pdfLink'],
        contents: (json['contents'] as List)
            .map((item) => Chapter.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "bibleStudyId": bibleStudyId,
      "coverImage": coverImage,
      "title": title,
      "subTitle": subTitle,
      "amount": amount,
      "pdfLink": pdfLink,
      "chapterNum": chapterNum,
      "contents": contents.map((item) => item.toJson()).toList()
    };
  }

  static List<BibleStudyMaterial> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => BibleStudyMaterial.fromJson(item)).toList();
  }
}
