import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Assuming LivingSeedMediaRouter is defined elsewhere
import 'package:livingseed_media/common/widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Define constants for professional look and consistency
  static const double _bookSize = 170;
  static const double _mediaIconRadius = 60;
  static const double _paddingValue = 25.0;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions once for layout decisions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/crop_germinating.jpeg'),
            fit: BoxFit.cover,
            // Use a dark filter for dramatic effect and text contrast
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_paddingValue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- 1. Visual Stack Section (Fixed Height for Stability) ---
              // This section takes up 50% of the screen height
              SizedBox(
                height: size.height * 0.5,
                child: Center(
                  child: _buildBookStack(context),
                ),
              ),

              // --- 2. Text & Button Section ---
              // This section takes up the remaining 50% of the screen height
              SizedBox(
                height: size.height * 0.5 - _paddingValue * 2,
                child: _buildTextAndButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the central visual stack with the book and overlapping icons.
  Widget _buildBookStack(BuildContext context) {
    // We use a SizedBox to give the Stack a fixed visual boundary
    return SizedBox(
      width: _bookSize * 2, // Ensure enough width for positioning
      height: _bookSize * 1.5 + _mediaIconRadius, // Ensure enough height
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Central Book Image (The main focus)
          bookImage("assets/images/tapping_god's_resources.jpeg", _bookSize),

          // 2. Audio Icon (Positioned relative to the main book, fixed distance)
          Positioned(
            left: 0,
            bottom: 50, // Fixed bottom spacing
            child: _buildMediaIcon(
              context,
              'assets/images/audioImage.png',
              _mediaIconRadius,
              Alignment.centerLeft,
            ),
          ),

          // 3. Video Icon (Positioned relative to the main book, fixed distance)
          Positioned(
            right: 0,
            top: 50, // Fixed top spacing
            child: _buildMediaIcon(
              context,
              'assets/images/video_image.jpeg',
              _mediaIconRadius,
              Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the text and call-to-action button section.
  Widget _buildTextAndButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          'Living Seed Media',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            fontFamily: 'Playfair',
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle/Motto
        Text(
          "Let's explore God's resources with Living Seed Media",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 80),

        // Get Started Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () =>
                GoRouter.of(context).go(LivingSeedRouter.signinPath),
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor:
                  Theme.of(context).primaryColor, // Use theme primary color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Get Started',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Playfair'),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget for the main book image with shadow.
  Widget bookImage(String imagePath, double size) {
    return Container(
      width: size,
      height: size * 1.4, // Adjusted aspect ratio for a taller book look
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            spreadRadius: 3,
            offset: Offset(0, 8),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Helper widget for the circular media icons (Audio/Video).
  Widget _buildMediaIcon(BuildContext context, String imagePath, double radius,
      Alignment alignment) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white, // Background for contrast
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          radius: radius - 4,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}
