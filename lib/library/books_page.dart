import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

class BooksPage extends StatefulWidget {
  final AboutBooks aboutBooks;
  const BooksPage({super.key, required this.aboutBooks});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late int allReviews;
  Color filledColor = Colors.orange.withOpacity(0.7);
  Color unfilledColor = Colors.grey;
  double starSize = 12.0;
  late Map<int, int> ratingCount;
  late int totalReviews;
  List<int>? ratings;

  @override
  void initState() {
    super.initState();
    if (widget.aboutBooks.ratingReviews.isNotEmpty) {
      allReviews = widget.aboutBooks.ratingReviews
          .map((review) => review.reviewRating.toInt())
          .reduce((a, b) => (a + b)); // sums all ratings
      ratings = widget.aboutBooks.ratingReviews
          .map((rating) => rating.reviewRating.toInt())
          .toList();
    } else {
      allReviews = 0;
      ratings = []; // ensure ratings is always initialized
    }
    _calculateRatings();
  }

  void _calculateRatings() {
    // Initialize map to store counts for each star (1-5)
    ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    if (ratings!.isNotEmpty) {
      // Count occurrences of each rating
      for (int rating in ratings!) {
        ratingCount[rating] = (ratingCount[rating] ?? 0) + 1;
      }
    }
    totalReviews = widget.aboutBooks.ratingReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return _bookGridView(context);
  }

  Widget _bookGridView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.aboutBooks != null) {
          GoRouter.of(context).go(
              '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBookPath}',
              extra: widget.aboutBooks);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 130,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  color: Theme.of(context).canvasColor,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(widget.aboutBooks.coverImage))),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.aboutBooks.bookTitle,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    widget.aboutBooks.author,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      widget.aboutBooks.ratingReviews.isNotEmpty
                          ? Text(
                              (allReviews /
                                      widget.aboutBooks.ratingReviews.length)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 10),
                            )
                          : Text(
                              '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 10),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            int averageRating = widget
                                    .aboutBooks.ratingReviews.isNotEmpty
                                ? (allReviews /
                                        widget.aboutBooks.ratingReviews.length)
                                    .floor()
                                : 0; // Default to 0 if there are no reviews

                            if (index < averageRating) {
                              // filled
                              return Icon(
                                Iconsax.star1,
                                color: filledColor,
                                size: starSize,
                              );
                            } else if (index < averageRating) {
                              // halffilled
                              return Icon(
                                Icons.star_half,
                                color: filledColor,
                                size: starSize,
                              );
                            } else {
                              // unfilled
                              return Icon(
                                Iconsax.star1,
                                color: unfilledColor,
                                size: starSize,
                              );
                            }
                          })),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
