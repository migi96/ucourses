// lib/domain/repositories/admin_repository.dart

import '../entities/admin_entity.dart';

// lib/domain/repositories/admin_repository.dart


abstract class AdminRepository {
  // Fetch admin details by admin ID
  Future<Admin> getAdminDetails(String adminId);

  // Update admin details
  Future<void> updateAdminDetails(Admin admin);

  // Add a method to fetch admin details by username for authentication
  Future<Admin> getAdminDetailsByUsername(String username);
  Future<bool> authenticateAdmin(String email, String password);
  // other methods
  Future<Admin> getAdminDetailsByEmail(String email);  // Add this line

}
