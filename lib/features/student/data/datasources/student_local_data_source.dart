import 'package:shared_preferences/shared_preferences.dart';

class StudentLocalDataSource {
  final SharedPreferences sharedPreferences;

  StudentLocalDataSource({required this.sharedPreferences});

  Future<void> saveStudentEmail(String email) async {
    await sharedPreferences.setString('email', email);
  }

  Future<String?> getStudentEmail() async {
    return sharedPreferences.getString('email');
  }
}
                                      




















                                       






                                       