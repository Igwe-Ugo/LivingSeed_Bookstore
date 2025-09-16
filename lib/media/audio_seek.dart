import 'dart:math';
import 'package:flutter/material.dart';

class DecibelNoiseMeter extends StatefulWidget {
  const DecibelNoiseMeter({super.key});

  @override
  DecibelNoiseMeterState createState() => DecibelNoiseMeterState();
}

class DecibelNoiseMeterState extends State<DecibelNoiseMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.repeat(reverse: true);
  }

  void stopAnimation() {
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(70, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double level = _random.nextDouble();
                  return Container(
                    height: 50 * level,
                    width: 10,
                    color: Colors.green,
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
