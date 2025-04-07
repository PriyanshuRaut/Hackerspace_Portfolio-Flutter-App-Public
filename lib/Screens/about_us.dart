import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../widgets/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Offset? _hoveredHexagon;
  int _currentIndex = 0;
  List<dynamic> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembersData();
  }

  // Load the members' data from JSON file
  Future<void> _loadMembersData() async {
    String jsonString = await rootBundle.loadString('assets/members.json');
    setState(() {
      _members = jsonDecode(jsonString);
    });
  }

  // Navigate to the next member
  void _nextMember() {
    setState(() {
      if (_currentIndex < _members.length - 1) {
        _currentIndex++;
      }
    });
  }

  // Navigate to the previous member
  void _previousMember() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_members.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final member = _members[_currentIndex]; // Get the current member details

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // About Us section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "About Us",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text Lorem Ipsum is simply dummy text of the psum is simply dummy text of the",
                        style: TextStyle(
                          color: Color(0xFF00FF95),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer
              const SizedBox(height: 20),

              // Our Journeys Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Our Journeys",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Timeline Layout
                      Column(
                        children: [
                          _buildTimelineItem("2022-2023", "Lorem Ipsum is simply dummy text."),
                          _buildTimelineItem("2022-2023", "Lorem Ipsum is simply dummy text."),
                          _buildTimelineItem("2022-2023", "Lorem Ipsum is simply dummy text."),
                          _buildTimelineItem("2022-2023", "Lorem Ipsum is simply dummy text."),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer
              const SizedBox(height: 20),

              // Our Experience Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(minHeight: 300), // Adjusted height constraint
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Our Experience",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Statistics Grid
                      GridView.count(
                        shrinkWrap: true, // Allows GridView to fit inside the column
                        physics: const NeverScrollableScrollPhysics(), // Disables GridView scrolling
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 2,
                        children: [
                          _buildStatItem("Projects Completed", "1000+"),
                          _buildStatItem("Members No", "100+"),
                          _buildStatItem("Ongoing Projects", "500+"),
                          _buildStatItem("Years Experience", "10+"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer
              const SizedBox(height: 20),

              // Members section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Our members",
                        style: TextStyle(color: Colors.white, fontSize: 36),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(member['image']),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${member['name']}",
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        member['role'],
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      if (member['description'] != null && member['description'] != "")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            member['description'],
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialMediaIcon('assets/images/linkedin.png', member['linkedin']),
                          const SizedBox(width: 10),
                          _buildSocialMediaIcon('assets/images/github.png', member['github']),
                          const SizedBox(width: 10),
                          _buildSocialMediaIcon('assets/images/twitter.png', member['twitter']),
                          const SizedBox(width: 10),
                          _buildSocialMediaIcon('assets/images/Instagram.png', member['instagram']),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _previousMember,
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: _nextMember,
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String year, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF00FF95),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 60,
              color: Colors.white,
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              border: Border.all(color: Color(0xFF00FF95), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  year,
                  style: const TextStyle(
                    color: Color(0xFF00FF95),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Function to build a single statistics box
  Widget _buildStatItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00FF95), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00FF95),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(
        assetPath,
        height: 24,
        width: 24,
        color: Colors.white,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}


class PointedHexagonGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Increase opacity to make the grid clearly visible
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const hexRadius = 30.0;
    final hexWidth = sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75) {
      bool isOffsetRow = ((y ~/ (hexHeight * 0.75)) % 2 == 1);
      for (double x = 0; x < size.width + hexWidth; x += hexWidth) {
        double xOffset = isOffsetRow ? hexWidth / 2 : 0;
        final center = Offset(x + xOffset, y);
        drawHexagon(canvas, gridPaint, center, hexRadius);
      }
    }
  }

  void drawHexagon(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 180 * (60 * i - 30);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}