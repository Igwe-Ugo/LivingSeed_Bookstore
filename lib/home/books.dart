// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class Books extends StatelessWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<BookProvider>(context, listen: false).booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading books"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found"));
        }
        List<AboutBooks> aboutBooks = snapshot.data!;
        return Column(
          children: aboutBooks
              .map((books) => buildBooks(context, aboutBooks: books))
              .toList(),
        );
      },
    );
  }

  Widget buildBooks(BuildContext context, {required AboutBooks aboutBooks}) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => GoRouter.of(context).go(
                  '${LivingSeedBookStoreRouter.homePath}/${LivingSeedBookStoreRouter.aboutBookPath}',
                  extra: aboutBooks),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 100,
                          width: 80,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(aboutBooks.coverImage))),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aboutBooks.bookTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  aboutBooks.author,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            buildStarRating(aboutBooks.ratingReviews),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'N${aboutBooks.amount.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStarRating(List<RatingReview> ratingReviews) {
    if (ratingReviews.isEmpty) {
      return Row(
        children: List.generate(
          5,
          (index) =>
              const Icon(Icons.star_border, color: Colors.grey, size: 16),
        ),
      );
    }

    // Compute average rating
    double averageRating =
        ratingReviews.map((r) => r.reviewRating).reduce((a, b) => a + b) /
            ratingReviews.length;

    int fullStars = averageRating.floor(); // Full stars
    bool hasHalfStar =
        (averageRating - fullStars) >= 0.5; // Check for half star
    int emptyStars =
        5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars

    return Row(
      children: [
        Text(
          averageRating.toStringAsFixed(2).toString(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        // Filled Stars
        ...List.generate(
          fullStars,
          (index) => const Icon(Iconsax.star1, color: Colors.orange, size: 16),
        ),

        // Half Star (if applicable)
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.orange, size: 16),

        // Empty Stars
        ...List.generate(
          emptyStars,
          (index) =>
              const Icon(Icons.star_border, color: Colors.grey, size: 16),
        ),
      ],
    );
  }
}
