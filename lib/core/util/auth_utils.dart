import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../init/screens/main_login_screen.dart';

// Dependency injection of FirebaseAuth instance
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void logout(BuildContext context) async {
  try {
    await firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainLoginScreen()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    // Log the error or handle it accordingly
    print("Error logging out: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to log out. Please try again.")),
    );
  }
}
