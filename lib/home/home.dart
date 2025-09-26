// ignore_for_file: unused_field

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPlaying = true;

  void _showInfoDialog(AboutBooks book) {
    setState(() {
      _isPlaying = false;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(book.bookTitle),
          content: Text(book.author),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPlaying = true;
                });
              },
              child: const Text('close'),
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
    return Consumer2<UsersAuthProvider, BookProvider>(
      builder: (context, userProvider, bookProvider, child) {
        if (userProvider.userData == null) {
          return const Scaffold(
            body: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Please log in to continue'),
              ],
            ),
          );
        }

        Users user = userProvider.userData!;
        List<AboutBooks> books = bookProvider.allBooks;

        return Scaffold(
          body: Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/LSeed-Logo-1.png', scale: 5),
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                        _buildDashboardCard(
                            context, 'Books', Icons.library_books, Colors.blue,
                            onTap: () => _goToPage(0)),
                        _buildDashboardCard(
                            context, 'Audios', Icons.graphic_eq, Colors.green,
                            onTap: () => _goToPage(1)),
                        _buildDashboardCard(
                            context, 'Videos', Icons.smart_display, Colors.red,
                            onTap: () => _goToPage(2)),
                      ],
                    ),
                  ],
                ),
              ),

              // PageView content
              Expanded(
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildBooksPage(List<AboutBooks> books) {
    return SingleChildScrollView(
      child: Padding(
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
              carouselController: _carouselController,
              itemCount: books.length,
              options: CarouselOptions(
                height: 250,
                autoPlay: _isPlaying,
                autoPlayInterval: const Duration(seconds: 10),
                viewportFraction: 0.95,
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
