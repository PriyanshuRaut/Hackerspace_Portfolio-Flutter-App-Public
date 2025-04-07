import 'dart:math';
import 'package:flutter/material.dart';

class MemberCard extends StatefulWidget {
  final String name;
  final String description;
  final String profileImage;
  final VoidCallback onTap;

  const MemberCard({
    required this.name,
    required this.description,
    required this.profileImage,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard>
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
                Colors.teal.withOpacity(0.6),
                Colors.orange.withOpacity(0.6),
                Colors.pink.withOpacity(0.6),
                Colors.lime.withOpacity(0.6),
                Colors.cyan.withOpacity(0.6),
                Colors.teal.withOpacity(0.6),
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
              leading: CircleAvatar(
                backgroundImage: AssetImage(widget.profileImage),
                radius: 25,
              ),
              title: Text(
                widget.name,
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
