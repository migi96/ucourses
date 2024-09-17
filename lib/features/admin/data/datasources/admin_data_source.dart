// lib/data/datasources/admin_data_source.dart

import '../../domain/entities/admin_entity.dart';

abstract class AdminDataSource {
  Future<Admin> getAdminDetails(String adminId);
  Future<void> updateAdminDetails(Admin admin);
    Future<bool> authenticateAdmin(String email, String password);
  Future<Admin> getAdminDetailsByUsername(String username);
  Future<Admin> getAdminDetailsByEmail(String email);  // Add this line

}



