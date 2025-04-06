import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hackerspace/contact_us.dart';
import 'package:hackerspace/profile_user.dart';
import 'about_us.dart';
import 'projects.dart';
import 'events.dart';
import 'our_members.dart';
import 'home_page.dart';
import 'add_members.dart';
import 'verify_members.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchAdminStatus();
  }

  Future<void> _fetchAdminStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = doc.data();

        if (data != null && data.containsKey('isAdmin')) {
          setState(() {
            isAdmin = data['isAdmin'] == true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching admin status: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Drawer(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/hackerspace_logo.jpeg', height: 80),
                  const SizedBox(height: 10),
                  const Text(
                    'Hacker Space',
                    style: TextStyle(
                      fontFamily: 'Audiowide',
                      fontSize: 28,
                      color: Color(0xFF00FF95),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _drawerTile(Icons.home, 'Home', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.info, 'About Us', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.lightbulb, 'Projects', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProjectsPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.event, 'Events', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const EventsPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.image, 'Our Members', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const GalleryPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.person_add, 'Add Members', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AddMembersPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.photo_album, 'Contact Us', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsPage()),
                  (route) => false,
            );
          }),
          _drawerTile(Icons.supervised_user_circle, 'Profile', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
                  (route) => false,
            );
          }),
          if (isAdmin)
            _drawerTile(Icons.verified_user, 'Verify Members', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VerifyMembersPage()),
              );
            }),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00FF95)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Audiowide', color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
