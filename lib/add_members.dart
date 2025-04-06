import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer_widget.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({Key? key}) : super(key: key);

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  // You can set a fixed value for isVerified as needed.
  final bool _isVerified = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add a member.')),
      );
      return;
    }
    Map<String, dynamic> memberData = {
      'name': _nameController.text.trim(),
      'role': _roleController.text.trim(),
      'image': _imageController.text.trim(),
      'category': _categoryController.text.trim(),
      'linkedin': _linkedinController.text.trim(),
      'github': _githubController.text.trim(),
      'twitter': _twitterController.text.trim(),
      'instagram': _instagramController.text.trim(),
      'isVerified': _isVerified,
      'addedBy': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    };
    CollectionReference collectionRef = _isVerified
        ? FirebaseFirestore.instance.collection('members')
        : FirebaseFirestore.instance.collection('notverify');
    try {
      await collectionRef.add(memberData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );
      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding member: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      drawer: const AppDrawer(),
      body: CustomPaint(
        painter: PointedHexagonGridPainter(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, 'Name', Icons.person),
                _buildTextField(_roleController, 'Role', Icons.work),
                _buildTextField(_imageController, 'Image URL', Icons.image),
                _buildTextField(_categoryController, 'Category', Icons.category),
                _buildTextField(_linkedinController, 'LinkedIn URL', Icons.link),
                _buildTextField(_githubController, 'GitHub URL', Icons.code),
                _buildTextField(_twitterController, 'Twitter URL', Icons.alternate_email),
                _buildTextField(_instagramController, 'Instagram URL', Icons.camera_alt),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF95),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Member'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF00FF95)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(0.5),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF00FF95), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
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
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final hoverPaint = Paint()
      ..color = const Color(0xFF00FF95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    const hexRadius = 30.0;
    final hexWidth = sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;
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
        drawHexagon(canvas, isHovered ? hoverPaint : gridPaint, center, hexRadius);
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
