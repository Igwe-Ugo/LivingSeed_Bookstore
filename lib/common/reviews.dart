import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget(
      {super.key,
      required this.context,
      required this.reviewText,
      required this.date,
      required this.reviewTitle,
      required this.reviewer,
      required this.rating,
      this.filledColor = Colors.orange,
      this.unfilledColor = Colors.grey,
      this.starSize = 12.0});

  final BuildContext context;
  final String reviewText;
  final String date;
  final String reviewTitle;
  final String reviewer;
  final int rating;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      if (index < rating.floor()) {
                        // filled
                        return Icon(
                          Iconsax.star1,
                          color: filledColor.withOpacity(0.7),
                          size: starSize,
                        );
                      } else if (index < rating) {
                        // haflfilled
                        return Icon(
                          Icons.star_half,
                          color: filledColor.withOpacity(0.7),
                          size: starSize,
                        );
                      } else {
                        return Icon(
                          Iconsax.star1,
                          color: unfilledColor,
                          size: starSize,
                        );
                      }
                    })),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '$reviewer - $date',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 11.0),
                ),
              ],
            ),
            Text(
              reviewText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.4,
        )
      ],
    );
  }
}
