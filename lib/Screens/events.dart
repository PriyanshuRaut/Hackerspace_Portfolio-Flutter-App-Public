import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import '../widgets/drawer_widget.dart';

// JSON Data (Replace it with an external JSON or API call if needed)
const String eventsData = '''
{
  "upcoming": [
    {
      "title": "Lorem Ipsum 1",
      "subtitle": "DESIGN AND DEVELOPMENT",
      "description": "Lorem Ipsum is simply dummy text of the printing",
      "image": "https://via.placeholder.com/120/FF0000/FFFFFF?text=Event+1"
    },
    {
      "title": "Lorem Ipsum 2",
      "subtitle": "DESIGN AND DEVELOPMENT",
      "description": "Lorem Ipsum is simply dummy text of the printing",
      "image": "https://via.placeholder.com/120/00FF00/FFFFFF?text=Event+2"
    }
  ],
  "past": [
    {
      "title": "Lorem Ipsum 1",
      "subtitle": "DESIGN AND DEVELOPMENT",
      "description": "Lorem Ipsum is simply dummy text of the printing",
      "image": "https://via.placeholder.com/120/0000FF/FFFFFF?text=Past+Event"
    },
    {
      "title": "Lorem Ipsum 2",
      "subtitle": "DESIGN AND DEVELOPMENT",
      "description": "Lorem Ipsum is simply dummy text of the printing",
      "image": "https://via.placeholder.com/120/0000FF/FFFFFF?text=Past+Event"
    }
  ]
}
''';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Offset? hoveredHexagon;
  List<dynamic> upcomingEvents = [];
  List<dynamic> pastEvents = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() {
    final jsonData = json.decode(eventsData);
    setState(() {
      upcomingEvents = jsonData['upcoming'];
      pastEvents = jsonData['past'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Hexagon Grid Background
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                hoveredHexagon = details.localPosition;
              });
            },
            onPanEnd: (_) {
              setState(() {
                hoveredHexagon = null;
              });
            },
            child: CustomPaint(
              painter: PointedHexagonGridPainter(hoveredHexagon: hoveredHexagon),
              size: MediaQuery.of(context).size,
            ),
          ),
          // Events Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildSectionTitle("Our Events"),
                buildSectionText(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been"),
                buildEventSection("Upcoming", upcomingEvents),
                buildEventSection("Past Events", pastEvents),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget buildEventSection(String title, List<dynamic> events) {
    final PageController _pageController = PageController();
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            buildSectionTitle(title),
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: events.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return buildEventCard(events[index]);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(events.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color(0xFF00FF95)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget buildEventCard(dynamic event) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00FF95), width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                event['image'] ?? 'https://via.placeholder.com/120',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, color: Colors.grey);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event['title'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00FF95)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['subtitle'],
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF00FF95)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['description'],
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            // Placeholder for Image

          ],
        ),
      ),
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
    final hexWidth = sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75) {
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
