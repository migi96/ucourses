import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucourses/firebase_options.dart';
import 'init/root.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
