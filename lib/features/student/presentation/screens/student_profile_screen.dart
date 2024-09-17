import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/shared/widgets/style/student_appbar.dart';
import '../cubit/student_cubit.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: AppTexts.profile, actions: studentAppBarActions(context)),
      body: GradientContainer(
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.thirdColor,
        myChild: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentLoggedIn) {
              return Center(
                child: Column(
                  children: [
                    // Profile Section
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 60,
                                child: Icon(
                                  Icons.person,
                                  size: 55,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.student.username,
                                style: Styles.style18,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                state.student.email,
                                style: Styles.style16,
                              ),
                              const SizedBox(height: 20),
                               Text(
                                          intl.DateFormat.yMMMd()
                                              .format(state.student.createdAt),
                                          style: Styles.style16),
                           
                              const SizedBox(height: 20),
                             
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is StudentError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No student data'));
            }
          },
        ),
      ),
    );
  }
}
