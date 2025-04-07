import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart'; // Ensure this file exists and is implemented
import 'dart:math';

class VerifyMembersPage extends StatefulWidget {
  const VerifyMembersPage({super.key});

  @override
  State<VerifyMembersPage> createState() => _VerifyMembersPageState();
}

class _VerifyMembersPageState extends State<VerifyMembersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> verifyMember(DocumentSnapshot memberDoc) async {
    try {
      final memberData = memberDoc.data() as Map<String, dynamic>;
      memberData['isVerified'] = true;

      await _firestore.collection('members').add(memberData);
      await _firestore.collection('notverify').doc(memberDoc.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member verified successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying member: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Verify Members'),
        backgroundColor: Colors.black,
      ),
      body: CustomPaint(
        painter: PointedHexagonGridPainter(),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('notverify').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong.'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No members to verify.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;

                return Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data['image'] ?? ''),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    data['role'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    'Category: ${data['category'] ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (data['linkedin'] != null)
                          Text(
                            "LinkedIn: ${data['linkedin']}",
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
                          ),
                        if (data['github'] != null)
                          Text(
                            "GitHub: ${data['github']}",
                            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
                          ),
                        if (data['twitter'] != null)
                          Text(
                            "Twitter: ${data['twitter']}",
                            style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w500),
                          ),
                        if (data['instagram'] != null)
                          Text(
                            "Instagram: ${data['instagram']}",
                            style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w500),
                          ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => verifyMember(docs[index]),
                            icon: const Icon(Icons.check),
                            label: const Text('Verify'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00FF95),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
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
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final hexRadius = 30.0;
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
