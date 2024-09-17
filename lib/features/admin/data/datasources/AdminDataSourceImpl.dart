// lib/data/datasources/admin_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/admin_entity.dart';
import 'admin_data_source.dart';

class AdminDataSourceImpl implements AdminDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Admin> getAdminDetails(String adminId) async {
    try {
      var doc = await firestore.collection('admins').doc(adminId).get();
      if (!doc.exists) {
        throw Exception('Admin not found');
      }
      return Admin(
        id: doc.id,
        name: doc.data()?['name'] ?? '',
        email: doc.data()?['email'] ?? '', password: doc.data()?['password'] ?? '', 
      );
    } catch (e) {
      print('Failed to fetch admin details: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateAdminDetails(Admin admin) async {
    try {
      await firestore.collection('admins').doc(admin.id).update({
        'name': admin.name,
        'email': admin.email
      });
      print("Admin details updated for ${admin.id}");
    } catch (e) {
      print('Failed to update admin details: $e');
      rethrow;
    }
  }

 @override
  Future<Admin> getAdminDetailsByUsername(String username) async {
    try {
      var querySnapshot = await firestore.collection('admins')
          .where('name', isEqualTo: username)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Admin not found');
      }
      var doc = querySnapshot.docs.first;
      return Admin(
        id: doc.id,
        name: doc.data()['name'] ?? '',
        email: doc.data()['email'] ?? '',
        password: doc.data()['password'] ?? ''
      );
    } catch (e) {
      print('Failed to fetch admin details: $e');
      rethrow;
    }
  }

// Inside AdminDataSourceImpl
@override
Future<bool> authenticateAdmin(String email, String password) async {
  try {
    var querySnapshot = await firestore.collection('admins')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false; // Username not found
    }
    var doc = querySnapshot.docs.first;
    return doc.data()['password'] == password; // Check if the passwords match
  } catch (e) {
    print('Authentication error: $e');
    return false;
  }
}

@override
Future<Admin> getAdminDetailsByEmail(String email) async {
  try {
    var querySnapshot = await firestore.collection('admins')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('Admin not found');
    }
    var doc = querySnapshot.docs.first;
    return Admin(
      id: doc.id,
      name: doc.data()['name'],
      email: doc.data()['email'],
      password: doc.data()['password']
    );
  } catch (e) {
    print('Failed to fetch admin details by email: $e');
    rethrow;
  }
}
}
