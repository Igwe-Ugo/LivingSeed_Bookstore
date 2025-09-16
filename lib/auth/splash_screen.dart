import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:livingseed_bookstore/common/widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInvisible = false;

  _SplashScreenState() {
    Timer(const Duration(seconds: 5), () {
      GoRouter.of(context).go(LivingSeedMediaRouter.landingPagePath);
    });
    Timer(const Duration(milliseconds: 5), () {
      setState(() {
        _isInvisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.5),
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0),
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isInvisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.video_collection,
                  size: 150.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Living Seed Media".toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Playfair',
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
