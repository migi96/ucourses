// lib/data/repositories/admin_repository_impl.dart

import '../../domain/entities/admin_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminDataSource dataSource;

  AdminRepositoryImpl(this.dataSource);

  @override
Future<bool> authenticateAdmin(String email, String password) {
  return dataSource.authenticateAdmin(email, password);
}

  @override
  Future<Admin> getAdminDetails(String adminId) async {
    return dataSource.getAdminDetails(adminId);
  }

   @override
  Future<Admin> getAdminDetailsByUsername(String username) async {
    return dataSource.getAdminDetailsByUsername(username);
  }
  
   @override
  Future<void> updateAdminDetails(Admin admin) async {
    return dataSource.updateAdminDetails(admin);
  }@override
Future<Admin> getAdminDetailsByEmail(String email) async {
  return dataSource.getAdminDetailsByEmail(email);
}
}
