// lib/presentation/cubit/admin_profile_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_entity.dart';
import '../../domain/usecases/admin_use_cases.dart';


class AdminProfileCubit extends Cubit<Admin?> {
  final AdminUseCases adminUseCases;

  AdminProfileCubit(this.adminUseCases) : super(null);

Future<void> getAdminDetails(String adminId) async {
  print("Fetching details for adminId: $adminId");  // Log the admin ID being used
  try {
    Admin admin = await adminUseCases.getAdminDetails(adminId);
    print("Fetched admin details: $admin");  // Debug log
    emit(admin);
  } catch (e) {
    print("Failed to fetch admin details: $e");  // Error log
    emit(null);
  }
}

Future<void> getAdminDetailsByEmail(String email) async {
  print("Fetching admin details for email: $email");
  try {
    Admin admin = await adminUseCases.getAdminDetailsByEmail(email);
    emit(admin);
  } catch (e) {
    print("Failed to fetch admin details: $e");
    emit(null);
  }}
  void updateAdminDetails(Admin admin) async {
    try {
      await adminUseCases.updateAdminDetails(admin);
      emit(admin);  // Re-emit updated admin details
      print("Admin details updated successfully");
    } catch (e) {
      print("Failed to update admin details: $e");  // Error log
    }
  }
}
