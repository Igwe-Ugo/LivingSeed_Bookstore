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
  bool _isPlaying = true;

  void _showInfoDialog(AboutBooks book) {
    // pause slider when tapped
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
                  child: const Text('close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UsersAuthProvider, BookProvider>(
        builder: (context, userProvider, bookProvider, child) {
      // Ensure userData is not null before accessing it
      if (userProvider.userData == null) {
        // Return a login screen or another appropriate widget
        return const Scaffold(
          body: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text('Please log in to continue'),
            ],
          ),
        );
      }
      Users user = userProvider.userData!;
      List<AboutBooks> books = bookProvider.allBooks;

      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/LSeed-Logo-1.png',
                          scale: 5,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Livingseed',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome\n${user.fullname}',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
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
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Livingseed Publications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: books.length,
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: _isPlaying,
                    autoPlayInterval: const Duration(
                        seconds:
                            15), // rotates every 15 seconds enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final bookItems = books[index];
                    return GestureDetector(
                      onTap: () => _showInfoDialog(bookItems),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            )
                          ],
                          image: DecorationImage(
                            image: AssetImage(bookItems.coverImage),
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
                                ]),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                bookItems.bookTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Playfair',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                bookItems.author,
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
                )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'View more in the Library section',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Livingseed Videos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
