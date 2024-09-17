import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ucourses/core/constants/app_text.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar_actions.dart';
import '../../../student/presentation/cubit/student_list_cubit.dart';
import '../../../student/domain/entities/student_entity.dart';
import '../../../student/data/models/course_model.dart';

class AdminStudentListScreen extends StatefulWidget {
  const AdminStudentListScreen({super.key});

  @override
  _AdminStudentListScreenState createState() => _AdminStudentListScreenState();
}

class _AdminStudentListScreenState extends State<AdminStudentListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
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

    BlocProvider.of<StudentListCubit>(context).fetchAllStudents();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.adminUserManagement,
        actions: customAppBarActions(context),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
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
                    child: Text(
                      AppTexts.userList,
                      style: Styles.style16White,
                    ),
                  ),
                ],
              ),
              const Divider(),
              BlocBuilder<StudentListCubit, StudentListState>(
                builder: (context, state) {
                  if (state is StudentListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StudentListLoaded) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    AppTexts.userName,
                                    style: Styles.style15grey,
                                  ),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.email, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    AppTexts.email,
                                    style: Styles.style15grey,
                                  ),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    AppTexts.createdAt,
                                    style: Styles.style15grey,
                                  ),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "المزيد",
                                style: Styles.style15grey,
                              ),
                            ),
                          ],
                          rows: state.students.map((student) {
                            return DataRow(
                              cells: [
                                DataCell(_buildAnimatedCell(
                                  context,
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 16, color: Colors.deepOrange),
                                      const SizedBox(width: 8),
                                      Text(student.username,
                                          style: Styles.style16),
                                    ],
                                  ),
                                )),
                                DataCell(_buildAnimatedCell(
                                  context,
                                  Row(
                                    children: [
                                      const Icon(Icons.email,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(student.email,
                                          style: Styles.style16),
                                    ],
                                  ),
                                )),
                                DataCell(_buildAnimatedCell(
                                  context,
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                          intl.DateFormat.yMMMd()
                                              .format(student.createdAt),
                                          style: Styles.style16),
                                    ],
                                  ),
                                )),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.expand_more,
                                        color: Colors.orange),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return CompletedCoursesBottomSheet(
                                              student: student);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else if (state is StudentListEmpty) {
                    return Center(
                      child: _buildAnimatedCell(
                        context,
                        const Text("لم يتم العثور على مستخدمين",
                            style: Styles.style16),
                      ),
                    );
                  } else {
                    return Center(
                      child: _buildAnimatedCell(
                        context,
                        const Text("حدث خطأ", style: Styles.style16),
                      ),
                    );
                  }
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCell(BuildContext context, Widget child) {
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
      child: child,
    );
  }
}

class CompletedCoursesBottomSheet extends StatelessWidget {
  final Student student;

  const CompletedCoursesBottomSheet({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppTexts.completedCourses,
              style: Styles.styleBold,
            ),
            const SizedBox(height: 10),
            if (student.completedCourses.isEmpty)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text("لا توجد دورات مكتملة", style: Styles.style16),
                ],
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: student.completedCourses.length,
                  itemBuilder: (context, index) {
                    final course = student.completedCourses[index];
                    return FutureBuilder<CourseModel>(
                      future: _fetchCourseDetails(course['courseId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Text("حدث خطأ أثناء تحميل الدورات",
                              style: Styles.style16);
                        } else if (!snapshot.hasData) {
                          return const Text("لم يتم العثور على دورة",
                              style: Styles.style16);
                        } else {
                          final courseDetails = snapshot.data!;
                          return ListTile(
                            title: Row(
                              children: [
                                const Icon(Icons.book, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(courseDetails.title,
                                    style: Styles.style16),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      title: const Text('تأكيد الحذف',textAlign: TextAlign.center,
                                          style: Styles.style18),
                                      content: const Text(
                                          'هل أنت متأكد أنك تريد حذف هذه الدورة؟',textAlign: TextAlign.center,
                                          style: Styles.style16),
                                      actions: [
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.grey,
                                          ),
                                          label: const Text('إلغاء',
                                              style: Styles.style16),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'حذف',
                                            style: Styles.style16White,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<StudentListCubit>(
                                                    context)
                                                .deleteCompletedCourse(
                                                    student.id,
                                                    course['courseId']);
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<CourseModel> _fetchCourseDetails(String courseId) async {
    final firestore = FirebaseFirestore.instance;
    final doc = await firestore.collection('courses').doc(courseId).get();
    return CourseModel.fromFirestore(
        doc.data() as Map<String, dynamic>, doc.id);
  }
}
