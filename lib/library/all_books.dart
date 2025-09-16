import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/library/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class AllBooks extends StatelessWidget {
  const AllBooks({super.key});

  final double _fontSize = 11;

  @override
  Widget build(BuildContext context) {
    return Consumer3<BookProvider, BibleStudyProvider, MagazineProvider>(
        builder: (context, bookProvider, bibleStudyProvider, magazineProvider,
            child) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Books',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.moreBooksPath}'),
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bookProvider.allBooks
                      .map((book) => BooksPage(aboutBooks: book))
                      .toList(),
                )),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bible Study Materials',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.moreBibleStudyPath}'),
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bibleStudyProvider.allBibleStudies
                      .map((bibleStudy) =>
                          BibleStudyPage(bibleStudy: bibleStudy))
                      .toList(),
                )),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Magazines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                        '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.moreMagazinePath}'),
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: magazineProvider.magazines
                      .map((mag) => MagazinePage(aboutMagazine: mag))
                      .toList(),
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
