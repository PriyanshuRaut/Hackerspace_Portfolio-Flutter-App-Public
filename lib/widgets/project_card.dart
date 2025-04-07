import 'dart:math';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const ProjectCard({
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
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
                Colors.red.withOpacity(0.6),
                Colors.blue.withOpacity(0.6),
                Colors.green.withOpacity(0.6),
                Colors.yellow.withOpacity(0.6),
                Colors.purple.withOpacity(0.6),
                Colors.red.withOpacity(0.6),
              ],
              stops: const [0, 0.2, 0.4, 0.6, 0.8, 1],
              transform: GradientRotation(_animation.value),
            ),
          ),
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Image.asset(widget.image, height: 50, fit: BoxFit.cover),
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontFamily: 'Audiowide'),
              ),
              subtitle: Text(
                widget.description,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: widget.onTap,
            ),
          ),
        );
      },
    );
  }
}
