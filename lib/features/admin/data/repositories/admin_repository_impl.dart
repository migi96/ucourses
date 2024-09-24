import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/admin_entity.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Admin> getAdminDetails(String adminId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('admins').doc(adminId).get();
      if (!doc.exists) {
        throw Exception('Admin not found');
      }
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Admin(
        id: doc.id,
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );
    } catch (e) {
      print("Error fetching admin details: $e");
      throw Exception('Failed to fetch admin details');
    }
  }

  @override
  Future<Admin> getAdminDetailsByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Admin not found');
      }
      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      return Admin(
        id: doc.id,
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );
    } catch (e) {
      print("Error fetching admin details by email: $e");
      throw Exception('Failed to fetch admin details by email');
    }
  }

  @override
  Future<void> updateAdminDetails(Admin admin) async {
    try {
      await firestore.collection('admins').doc(admin.id).update({
        'name': admin.name,
        'email': admin.email,
      });
      print("Admin details updated successfully");
    } catch (e) {
      print("Error updating admin details: $e");
      throw Exception('Failed to update admin details');
    }
  }

  @override
  Future<bool> authenticateAdmin(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false; // Admin with the provided email doesn't exist
      }

      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;

      // Check if the password matches
      if (data['password'] == password) {
        return true; // Authentication successful
      } else {
        return false; // Authentication failed
      }
    } catch (e) {
      print("Error authenticating admin: $e");
      throw Exception('Failed to authenticate admin');
    }
  }

  @override
  Future<Admin> getAdminDetailsByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('admins')
          .where('name', isEqualTo: username)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Admin not found');
      }

      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      return Admin(
        id: doc.id,
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );
    } catch (e) {
      print("Error fetching admin details by username: $e");
      throw Exception('Failed to fetch admin details by username');
    }
  }
}
