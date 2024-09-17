import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_icon.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import '../../../../core/shared/widgets/style/custom_appbar_actions.dart';
import '../../domain/entities/admin_entity.dart';
import '../cubit/admin_profile_cubit.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchAdminDetails();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchAdminDetails() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      BlocProvider.of<AdminProfileCubit>(context, listen: false)
          .getAdminDetailsByEmail(user.email!);
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.profile,
        actions: customAppBarActions(context),
      ),
      body: BlocBuilder<AdminProfileCubit, Admin?>(
        builder: (context, admin) {
          if (admin == null) {
            return const Center(
                child:
                    SizedBox(height: 120, width: 120, child: LottieLoading()));
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              children: <Widget>[
                _buildAnimatedAvatar(),
                const SizedBox(height: 50),
                _buildAnimatedCard(
                  icon: Icons.person,
                  title: AppTexts.userName,
                  subtitle: admin.name,
                ),
                const SizedBox(height: 15),
                _buildAnimatedCard(
                  icon: Icons.email,
                  title: AppTexts.email,
                  subtitle: admin.email,
                ),
                const SizedBox(height: 30),
                _buildAnimatedButton(context, admin),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
      child: CircleAvatar(
        maxRadius: 50,
        child: GradientIcon(
          firstGradientColor: AppColors.primaryColor,
          secondGradientColor: AppColors.fifthColor,
          myChild: Lottie.asset(
            'lib/assets/jsons/animation/admin_profile.json',
            height: 130,
            repeat: false,
            width: 130,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(icon, color: Colors.deepOrange),
          title: Text(title, style: Styles.style15grey),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, Admin admin) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 550, right: 550),
        child: ElevatedButton.icon(
          onPressed: () => _editAdminProfile(context, admin),
          icon: const Icon(Icons.edit),
          label: const Text(
            AppTexts.editProfile,
            style: Styles.style16,
          ),
        ),
      ),
    );
  }

  void _editAdminProfile(BuildContext context, Admin admin) {
    TextEditingController nameController =
        TextEditingController(text: admin.name);
    TextEditingController emailController =
        TextEditingController(text: admin.email);
    TextEditingController passwordController =
        TextEditingController(text: admin.password);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text(
            AppTexts.editAdminProfile,
            textAlign: TextAlign.center,
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: AppTexts.userName, labelStyle: Styles.style16),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: AppTexts.email, labelStyle: Styles.style16),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: AppTexts.password, labelStyle: Styles.style16),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              label: const Text(AppTexts.cancel, style: Styles.style16),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Admin updatedAdmin = Admin(
                    id: admin.id,
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text);
                BlocProvider.of<AdminProfileCubit>(context)
                    .updateAdminDetails(updatedAdmin);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.save,
                color: Colors.green,
              ),
              label: const Text(
                AppTexts.save,
                style: Styles.style16,
              ),
            ),
          ],
        );
      },
    );
  }
}
