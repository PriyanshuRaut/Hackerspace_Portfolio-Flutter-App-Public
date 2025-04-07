import 'package:flutter/material.dart';
import 'dart:math';
import 'widgets/drawer_widget.dart';
import 'Screens/about_us.dart';
import 'Screens/projects.dart';
import 'Members/our_members.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'widgets/about_us_card.dart';
import 'widgets/member_card.dart';
import 'widgets/project_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontFamily: 'Audiowide', // Custom font
            color: Color(0xFF00FF95),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    Offset? _hoveredHexagon;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacker Space"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Hexagonal background
          GestureDetector(
            onPanUpdate: (details) {
              _hoveredHexagon = details.localPosition;
            },
            onPanEnd: (_) {
              _hoveredHexagon = null;
            },
            child: CustomPaint(
              painter: PointedHexagonGridPainter(
                  hoveredHexagon: _hoveredHexagon),
              size: MediaQuery
                  .of(context)
                  .size,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/hackerspace_logo.jpeg',
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(
                        height: 40,
                        child: Text(
                              "Hacker Space",
                               style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 40, // Adjust height for better spacing
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Let's hack the future",
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // About Us Section
                _buildSectionTitle("About Us"),
                _buildSectionCard(
                  content:
                  "Hacker Space is a community of tech enthusiasts driven by innovation and collaboration. Join us to explore the cutting edge of technology!",
                  buttonText: "Learn More",
                  onButtonPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsPage(),
                      ),
                          (route) => false,
                    );
                  },
                ),

                // Projects Section
                _buildSectionTitle("Our Projects"),
                _buildProjectCard(
                  title: "Lorem Ipsum",
                  description:
                  "Explore our latest projects in cybersecurity, AI, and open-source.",
                  image: 'assets/images/sample_project.png',
                  onTap: () {
                    // Define the action when the card is clicked
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectsPage(),
                      ),
                          (route) => false,
                    );
                  },
                ),

                // Members Section
                _buildSectionTitle("Our Members"),
                _buildMemberCard(
                  name: "John Doe",
                  description:
                  "An AI enthusiast with a passion for open-source projects.",
                  profileImage: 'assets/images/member1.png',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryPage(),),
                          (route) => false,
                    );

                  },
                ),

                // Connect With Us Section
                _buildSectionTitle("Connect With Us"),
                const _ConnectWithUsSection(),

                // Footer Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "© 2024 Hacker Space. All Rights Reserved.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Audiowide',
          color: Color(0xFF00FF95),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String content,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return AnimatedGlowingBorderCard(
      content: content,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required String image,
    required VoidCallback onTap,
  }) {
    return ProjectCard(
      title: title,
      description: description,
      image: image,
      onTap: onTap,
    );
  }

  Widget _buildMemberCard({
    required String name,
    required String description,
    required String profileImage,
    required VoidCallback onTap,
  }) {
    return MemberCard(
      name: name,
      description: description,
      profileImage: profileImage,
      onTap: onTap,
    );
  }
}

class _ConnectWithUsSection extends StatelessWidget {
  const _ConnectWithUsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.email, color: Color(0xFF00FF95)),
          onPressed: () {},
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/linkedin.png',
            height: 40,
            width: 40,
          ),
          onPressed: () {
            // LinkedIn button action
          },
        ),
        IconButton(
          icon: const Icon(Icons.web, color: Color(0xFF00FF95)),
          onPressed: () {},
        ),
      ],
    );
  }
}

class PointedHexagonGridPainter extends CustomPainter {
  final Offset? hoveredHexagon;

  PointedHexagonGridPainter({this.hoveredHexagon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final hoverPaint = Paint()
      ..color = const Color(0xFF00FF95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const hexRadius = 30.0;
    final hexWidth = sqrt(3) * hexRadius; // Width of each hexagon
    final hexHeight = 2 * hexRadius; // Height of each hexagon
    const verticalSpacing = 0.0;

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75 + verticalSpacing) {
      bool isOffsetRow = ((y ~/ (hexHeight * 0.75)) % 2 == 1);

      for (double x = 0; x < size.width + hexWidth; x += hexWidth) {
        double xOffset = isOffsetRow ? hexWidth / 2 : 0;

        final center = Offset(x + xOffset, y);

        if (center.dx - hexRadius > size.width || center.dy - hexRadius > size.height) {
          continue;
        }

        final isHovered = hoveredHexagon != null &&
            (center - hoveredHexagon!).distance <= hexRadius * 2;

        drawHexagon(canvas, isHovered ? hoverPaint : paint, center, hexRadius);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
