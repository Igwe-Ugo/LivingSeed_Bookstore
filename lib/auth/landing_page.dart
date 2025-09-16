import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_bookstore/common/widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Backmost book (most rotated)
                          Positioned(
                            left: 80,
                            child: Transform.rotate(
                              angle: 0.6,
                              child: bookImage(
                                  'assets/images/no_more_two.jpeg', 170),
                            ),
                          ),

                          // Middle book
                          Positioned(
                            right: 80,
                            child: Transform.rotate(
                              angle: -0.6,
                              child: bookImage(
                                  'assets/images/exploring_god.jpeg', 170),
                            ),
                          ),

                          // Front book (upright)
                          bookImage(
                              "assets/images/tapping_god's_resources.jpeg",
                              170),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Living Seed Book Store',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Let's read books with Living Seed Store",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => GoRouter.of(context)
                          .go(LivingSeedMediaRouter.signinPath),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(10, 50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Get Started',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
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

  Widget bookImage(String imagePath, double size) {
    return Container(
      width: size,
      height: size * 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
