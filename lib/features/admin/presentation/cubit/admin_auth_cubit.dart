import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/admin_use_cases.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminAuthState { initial, loading, authenticated, error, unauthenticated }

class AdminAuthCubit extends Cubit<AdminAuthState> {
  final AdminUseCases adminUseCases;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AdminAuthCubit(this.adminUseCases) : super(AdminAuthState.initial);

  Future<void> authenticateAdmin(String email, String password) async {
    emit(AdminAuthState.loading);
    try {
      // Authenticate with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        // Check if the authenticated user is in the 'admins' collection
        var adminDoc = await firestore.collection('admins')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

        if (adminDoc.docs.isNotEmpty) {
          emit(AdminAuthState.authenticated);
        } else {
          // If user is not an admin, log them out immediately
          await FirebaseAuth.instance.signOut();
          emit(AdminAuthState.error);
        }
      } else {
        emit(AdminAuthState.error);
      }
    } catch (e) {
      print('Authentication Error: $e');
      if (e is FirebaseAuthException) {
        print('Firebase Auth Exception Code: ${e.code}');
        print('Firebase Auth Exception Message: ${e.message}');
      }
      emit(AdminAuthState.error);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(AdminAuthState.unauthenticated);
    } catch (e) {
      print('Logout Error: $e');
      emit(AdminAuthState.error);
    }
  }
}
