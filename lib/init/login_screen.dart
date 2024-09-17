// import 'package:flutter/material.dart';
// import '../features/student/presentation/screens/student_login_screen.dart';
// import 'screens/main_login_screen.dart';
// import 'widgets/widget_exports.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   void _selectTab(int index) {
//     _tabController.animateTo(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const HomeNavigation(),
//             Column(
//               children: [
//                 const SizedBox(height: 16),
//                 TextButton.icon(
//                   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const StudentLoginScreen(),
//                   )),
//                   icon: const Icon(Icons.person, color: Colors.blue),
//                   label:
//                       const Text('طالب', style: TextStyle(color: Colors.blue)),
//                   style: TextButton.styleFrom(
//                     alignment:
//                         Alignment.centerRight, // Place the icon on the right
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const MainLoginScreen(),
//                   )),
//                   icon: const Icon(Icons.admin_panel_settings,
//                       color: Colors.blue),
//                   label:
//                       const Text('مدير', style: TextStyle(color: Colors.blue)),
//                   style: TextButton.styleFrom(
//                     alignment:
//                         Alignment.centerRight, // Place the icon on the right
//                   ),
//                 ),
//               ],
//             ),
//             // Main content area (TabBarView)
//             // const StudentLoginScreen(),
//             const MainLoginScreen(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
