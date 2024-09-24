// lib/domain/repositories/admin_repository.dart

import '../entities/admin_entity.dart';

// lib/domain/repositories/admin_repository.dart

abstract class AdminRepository {
  // Fetch admin details by admin ID
  Future<Admin> getAdminDetails(String adminId);

  // Fetch admin details by email
  Future<Admin> getAdminDetailsByEmail(String email);

  // Update admin details
  Future<void> updateAdminDetails(Admin admin);
  // Update admin details

  // Add a method to fetch admin details by username for authentication
  Future<Admin> getAdminDetailsByUsername(String username);
  Future<bool> authenticateAdmin(String email, String password);
  // other methods
}
