import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/library/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
//import 'package:livingseed_bookstore/services/widget.dart';
//import 'package:provider/provider.dart';

class AboutBook extends StatefulWidget {
  final AboutBooks aboutBooks;
  const AboutBook({super.key, required this.aboutBooks});

  @override
  State<AboutBook> createState() => _AboutBookState();
}

class _AboutBookState extends State<AboutBook> {
  bool more = false;
  late int allReviews;
  Color filledColor = Colors.orange.withOpacity(0.7);
  Color unfilledColor = Colors.grey;
  double starSize = 30.0;
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
      ratings = [];
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

    // Get total number of reviews
    totalReviews = widget.aboutBooks.ratingReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: const Icon(
                Iconsax.arrow_left_2,
                size: 17,
              )),
          title: Text(
            widget.aboutBooks.bookTitle,
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 130,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(widget.aboutBooks.coverImage),
                          )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UsersAuthProvider>(context, listen: false)
                          .addToBookCart(widget.aboutBooks);
                      Users user =
                          Provider.of<UsersAuthProvider>(context, listen: false)
                              .userData!;
                      NotificationItems newNotification = NotificationItems(
                        notificationImage: widget.aboutBooks.coverImage,
                        notificationTitle: 'Book added to cart',
                        notificationMessage:
                            'A book with the name: ${widget.aboutBooks.bookTitle} has been added to your cart item. You can view it in your cart session. You have done a great job by uplisting this in your purchases, do well to purchase!',
                        notificationDate:
                            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                        notificationTime:
                            "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
                      );
                      Provider.of<NotificationProvider>(context, listen: false)
                          .sendPersonalNotification(
                              user.emailAddress, newNotification);

                      NotificationDropDownServices notificationId =
                          NotificationDropDownServices();

                      NotificationDropDownServices.showNotification(
                          id: notificationId.getNextId(),
                          title: 'Book Added to cart',
                          body:
                              "The book with the name ${widget.aboutBooks.bookTitle} has been added to your cart"
                                  .substring(0, 5));
                      showMessage('Book has been added to Cart', context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      minimumSize: const Size(10, 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₦ ${widget.aboutBooks.amount.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 17,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Add to Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.white),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.aboutBooks.bookTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.aboutBooks.author,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).disabledColor.withOpacity(0.4),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                int averageRating = widget
                                        .aboutBooks.ratingReviews.isNotEmpty
                                    ? (allReviews /
                                            widget.aboutBooks.ratingReviews
                                                .length)
                                        .floor()
                                    : 0; // Default to 0 if there are no reviews

                                if (index < averageRating) {
                                  // filled
                                  return Icon(
                                    Iconsax.star1,
                                    color: filledColor,
                                    size: starSize,
                                  );
                                } else if (index <
                                    (allReviews /
                                        widget
                                            .aboutBooks.ratingReviews.length)) {
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
                          widget.aboutBooks.ratingReviews.isNotEmpty
                              ? Text(
                                  (allReviews /
                                          widget
                                              .aboutBooks.ratingReviews.length)
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  '0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (widget.aboutBooks != null) {
                              GoRouter.of(context).go(
                                  '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBookPath}/${LivingSeedMediaRouter.reviewsPath}',
                                  extra: widget.aboutBooks);
                            }
                          },
                          child: Text(
                            'See Reviews',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).disabledColor.withOpacity(0.4),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("What's it about?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.aboutBooks.aboutBook,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: more == false ? 5 : 30,
                        textAlign: TextAlign.justify,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              more = !more;
                            });
                          },
                          child: Text(
                            more == false ? 'see more...' : 'see less...',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Have ${widget.aboutBooks.chapterNum} Chapters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
                        itemCount: widget.aboutBooks.chapters
                            .length, // Loops through list of maps
                        itemBuilder: (context, index) {
                          Map<String, String> chapterMap =
                              widget.aboutBooks.chapters[index]; // Get Map

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: chapterMap.entries.map((entry) {
                              return Container(
                                margin: const EdgeInsets.all(7),
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 10),
                                  child: Text(
                                    "${entry.key}: ${entry.value}", // Displays "Chapter 1: God's Great Offer"
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Who is the author?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.aboutBooks.aboutAuthor,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text("Recommended for you",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              BooksPage(
                                aboutBooks: widget.aboutBooks,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
