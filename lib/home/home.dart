// ignore_for_file: unused_field

import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // final CarouselSliderController _carouselController = CarouselSliderController(); // Unused and commented out
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPlaying = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showInfoDialog(AboutBooks book) {
    const double fontSize = 13.0;
    setState(() {
      // Pause carousel when dialog is shown
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
            style: const TextStyle(
                fontFamily: 'Playfair',
                fontSize: 17,
                fontWeight: FontWeight.w900),
          ),
          content: SizedBox(
            height: 170, // Fixed height for the content area
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.author,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  // Use Expanded for the main text body
                  child: Text(
                    book.aboutBook,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
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
                    fontSize: fontSize, color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'close'.toUpperCase(),
                style: TextStyle(
                    fontSize: fontSize, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      // Resume carousel after dialog is dismissed
      setState(() {
        _isPlaying = true;
      });
    });
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
    return Consumer4<UsersAuthProvider, BookProvider, JournalProvider,
        AddEventProvider>(
      builder: (context, userProvider, bookProvider, journalProvider,
          eventProvider, child) {
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
        List<UpcomingEventsModel> upcomingEvents = eventProvider.events;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
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
                  height: MediaQuery.of(context).size.height * 0.36,
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

                // --- Journal Section Header ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LIVING JOURNAL',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Playfair',
                            ),
                          ),
                          const Text(
                            'Latest Posts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                ),
                const SizedBox(height: 10),

                // --- Journal Posts Horizontal List ---
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.51, // Fixed height
                  child: ListView.builder(
                    itemCount: journalPost.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true, // Only for list inside a bounded parent
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final journal = journalPost[index];
                      // buildBlogCard handles its own width constraint
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

                // --- Upcoming Meetings Header ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Upcoming Meetings',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair',
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // --- Upcoming Events Horizontal List ---
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true, // Only for list inside a bounded parent
                    physics: const ClampingScrollPhysics(),
                    itemCount: upcomingEvents.length,
                    itemBuilder: (context, index) {
                      final events = upcomingEvents[index];
                      // buildEventCard handles its own width constraint
                      return buildEventCard(
                          context,
                          events.eventImageUrl,
                          events.eventName,
                          events.to,
                          events.from,
                          events.eventVenue,
                          events);
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventImage(String path) {
    if (path.isEmpty) {
      return Container(
        height: 180,
        color: Colors.grey.shade200,
        child: const Center(child: Text('No Image')),
      );
    }

    bool isFile = !path.startsWith('assets/');

    return isFile
        ? Image.file(
            File(path),
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.3),
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.red.shade100,
              child: const Center(child: Text('File Error')),
            ),
          )
        : Image.asset(
            path,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.3),
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.red.shade100,
              child: const Center(child: Text('Asset Error')),
            ),
          );
  }

  Widget buildEventCard(
      BuildContext context,
      String imageUrl,
      String eventTitle,
      DateTime to,
      DateTime from,
      String eventVenue,
      UpcomingEventsModel upcomingEvents) {
    // --- Info Chip Widget ---
    Widget _buildInfoChip(String dateText, String timeText) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 4,
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 15),
            Text(
              dateText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.schedule, color: Colors.white, size: 15),
            Text(
              timeText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // --- Metadata Row Widget ---
    Widget _buildMetadataRow({required IconData icon, required String text}) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    // --- Main Card Layout ---
    return SizedBox(
      width: 350, // Apply fixed width
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 15,
              child: _buildEventImage(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title ---
                  Text(
                    eventTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Playfair',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Info Chip ---
                  _buildInfoChip(
                    '${from.day}/${from.month} - ${to.day}/${to.month}',
                    "${from.hour.toString().padLeft(2, '0')}:${from.minute.toString().padLeft(2, '0')} - "
                        "${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}",
                  ),

                  const SizedBox(height: 15),

                  // --- Venue Row ---
                  _buildMetadataRow(
                    icon: Icons.location_on,
                    text: eventVenue,
                  ),
                  const SizedBox(height: 10),
                  // Read More Link (Underlined)
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go(
                          '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.upcomingEventsPath}/${LivingSeedMediaRouter.viewUpcomingEventsPath}',
                          extra: upcomingEvents);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 2,
                          width: 55, // Width of the underline
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

  /// A functional widget that builds the complete blog post card layout.
  Widget buildBlogCard({
    required BuildContext context,
    required String imageUrl,
    required JournalPost date,
    required String title,
    required String author,
    required JournalPost category,
    required VoidCallback onReadMore,
  }) {
    Widget buildMetadataRow({required IconData icon, required String text}) {
      return Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: 350,
      child: Card(
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
                    aspectRatio: 16 / 11, child: _buildEventImage(imageUrl)),

                // Vertical Date Banner
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 35,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
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
                          quarterTurns: 3,
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
                    overflow: TextOverflow.ellipsis,
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
    // Using SizedBox to explicitly constrain the size of the Card (Good Practice)
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 120, // Define height on the inner Container
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: color),
                const SizedBox(height: 10),
                Text(title,
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
