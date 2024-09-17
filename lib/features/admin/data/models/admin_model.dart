// lib/data/models/admin_model.dart

import '../../domain/entities/admin_entity.dart';

class AdminModel extends Admin {
  AdminModel({required super.id, required super.name, required super.email, required super.password});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
            password: json['password'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
            'password': password,

    };
  }
}
