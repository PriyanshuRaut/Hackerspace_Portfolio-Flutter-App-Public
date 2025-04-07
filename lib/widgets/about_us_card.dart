import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedGlowingBorderCard extends StatefulWidget {
  final String content;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const AnimatedGlowingBorderCard({
    required this.content,
    required this.buttonText,
    required this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedGlowingBorderCardState createState() =>
      _AnimatedGlowingBorderCardState();
}

class _AnimatedGlowingBorderCardState extends State<AnimatedGlowingBorderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: SweepGradient(
              colors: [
                Colors.red.withOpacity(0.7),
                Colors.orange.withOpacity(0.7),
                Colors.yellow.withOpacity(0.7),
                Colors.green.withOpacity(0.7),
                Colors.blue.withOpacity(0.7),
                Colors.indigo.withOpacity(0.7),
                Colors.purple.withOpacity(0.7),
                Colors.red.withOpacity(0.7), // Complete the circle
              ],
              stops: const [0, 0.16, 0.33, 0.5, 0.66, 0.83, 0.99, 1],
              transform: GradientRotation(_animation.value),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.content,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: widget.onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF95),
                        foregroundColor: Colors.black,
                      ),
                      child: Text(widget.buttonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
