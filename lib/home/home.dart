// ignore_for_file: unused_field

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Note: Assuming these imports exist in your project structure
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

import '../common/widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Use 'late' keyword if these are expected to be initialized elsewhere
  // final CarouselSliderController _carouselController = CarouselSliderController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPlaying = true;

  void _showInfoDialog(AboutBooks book) {
    double _fontSize = 13.0;
    setState(() {
      _isPlaying = false;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            book.bookTitle,
            style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 17,
                fontWeight: FontWeight.w900),
          ),
          content: SizedBox(
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.author,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  book.aboutBook,
                  maxLines: 7,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                GoRouter.of(context).go(
                    '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBookPath}',
                    extra: book);
              },
              child: Text(
                'See more'.toUpperCase(),
                style: TextStyle(
                    fontSize: _fontSize, color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'close'.toUpperCase(),
                style: TextStyle(
                    fontSize: _fontSize, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: Removed the PageView's onPageChanged and replaced it with local state management.
    return Consumer3<UsersAuthProvider, BookProvider, JournalProvider>(
      builder: (context, userProvider, bookProvider, journalProvider, child) {
        if (userProvider.userData == null) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Please log in to continue'),
                ],
              ),
            ),
          );
        }

        Users user = userProvider.userData!;
        List<AboutBooks> books = bookProvider.allBooks;
        List<JournalPost> journalPost = journalProvider.allPosts;

        return Scaffold(
          // WRAP THE BODY IN A SINGLECHILDSCROLLVIEW
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align to start for better look
              children: [
                // header
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Using a placeholder for the asset image path
                          Image.asset('assets/icons/LSeed-Logo-1.png',
                              scale: 5),
                          const SizedBox(width: 5),
                          const Text(
                            'Livingseed',
                            style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Welcome\n${user.fullname}',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Playfair',
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(user.userImage),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // horizontal tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDashboardCard(context, 'Books',
                              Icons.library_books, Colors.blue,
                              onTap: () => _goToPage(0)),
                          _buildDashboardCard(
                              context, 'Audios', Icons.graphic_eq, Colors.green,
                              onTap: () => _goToPage(1)),
                          _buildDashboardCard(context, 'Videos',
                              Icons.smart_display, Colors.red,
                              onTap: () => _goToPage(2)),
                        ],
                      ),
                    ],
                  ),
                ),

                // PageView content (GIVE IT A FIXED HEIGHT NOW)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Books Page
                      _buildBooksPage(books),

                      // Audios Page
                      Center(
                        child: Text(
                          "Audios Section",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),

                      // Videos Page
                      Center(
                        child: Text(
                          "Videos Section",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'LIVING JOURNAL',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'Latest Posts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.homePath}/${LivingSeedMediaRouter.journalPath}');
                      },
                      child: Text(
                        'View More >',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.33, // Give fixed height for the horizontal card section
                  child: ListView.builder(
                    itemCount: journalPost.length,
                    // Changed Row + SingleChildScrollView to ListView.builder for proper behavior
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final journal = journalPost[index];
                      return buildBlogCard(
                          context: context,
                          imageUrl: journal.imageUrl,
                          date: journal,
                          title: journal.title,
                          author: journal.authorName,
                          category: journal,
                          onReadMore: () {
                            GoRouter.of(context).go(
                                '${LivingSeedMediaRouter.homePath}/${LivingSeedMediaRouter.journalPath}/${LivingSeedMediaRouter.journalDetailsPath}',
                                extra: journal);
                          });
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  /// A functional widget that builds the complete blog post card layout.
  ///
  /// It takes all content data as parameters, making it highly reusable.
  Widget buildBlogCard({
    required BuildContext context,
    required String imageUrl,
    required JournalPost date,
    required String title,
    required String author,
    required JournalPost category,
    required VoidCallback onReadMore,
  }) {
    const double kMaxBlogCardWidth = 360.0;
    final cardWidth = (MediaQuery.of(context).size.width * 0.9)
        .clamp(150.0, kMaxBlogCardWidth);
    Widget buildMetadataRow({required IconData icon, required String text}) {
      return Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      // Wrap in a SizedBox to constrain the width for horizontal scrolling
      width: cardWidth,
      child: Card(
        // Clip the card content to respect the border radius
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image and Vertical Date Banner Stack
            Stack(
              children: [
                // Image Area
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    // Changed Image.network to Image.asset for local paths
                    imageUrl,
                    fit: BoxFit.cover,
                    // Add a filter to darken the image and enhance drama, matching the original photo's mood
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.4),
                    // Removed errorBuilder since we are using local assets now
                  ),
                ),

                // Vertical Date Banner
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0, // Stretch vertically to the image height
                  child: Container(
                    width: 35, // Fixed width for the vertical banner
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      // Only round the top-left corner as the banner is part of the clipped Card
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Calendar Icon
                        const Icon(Icons.calendar_today,
                            size: 18, color: Colors.white),
                        const SizedBox(height: 12),
                        // Rotated Date Text
                        RotatedBox(
                          quarterTurns:
                              3, // Rotate 270 degrees (vertical text orientation)
                          child: Text(
                            '${date.date.day}-${date.date.month}-${date.date.year}'
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 2. Text Content Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Playfair',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author Row
                  buildMetadataRow(
                    icon: Icons.person_rounded,
                    text: author,
                  ),
                  const SizedBox(height: 8),

                  // Category Row
                  buildMetadataRow(
                    icon: Icons.folder_open,
                    text: category.category.name,
                  ),
                  const SizedBox(height: 20),

                  // Read More Link (Underlined)
                  InkWell(
                    onTap: onReadMore,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read More',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 2,
                          width: 85, // Width of the underline
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksPage(List<AboutBooks> books) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Featured",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CarouselSlider.builder(
            // NOTE: If _carouselController is not used, remove it to avoid runtime errors
            // carouselController: _carouselController,
            itemCount: books.length,
            options: CarouselOptions(
              height: 250,
              autoPlay: _isPlaying,
              autoPlayInterval: const Duration(seconds: 10),
              viewportFraction: 0.97,
            ),
            itemBuilder: (context, index, realIndex) {
              final book = books[index];
              return GestureDetector(
                onTap: () => _showInfoDialog(book),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(book.coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.84),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          book.bookTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          book.author,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, IconData icon, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 120,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
