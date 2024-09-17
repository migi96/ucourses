import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/core/constants/constants_exports.dart';
import 'package:ucourses/core/shared/widgets/style/lottie_loading.dart';
import 'package:ucourses/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/core/shared/widgets/style/custom_appbar.dart';
import 'package:ucourses/features/admin/presentation/widgets/dialogs.dart';
import 'package:ucourses/features/admin/presentation/widgets/course_search_widget.dart';
import '../../../../core/util/auth_utils.dart';
import '../../../../main.dart';
import '../cubit/admin_state.dart';
import '../widgets/course_grid.dart';

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen>
    with RouteAware {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<AdminCubit>()
        .getCourses(); // Load courses when the screen initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    context
        .read<AdminCubit>()
        .getCourses(); // Reload courses when returning to this screen
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      context
          .read<AdminCubit>()
          .getCourses(); // Reload all courses when search is cleared
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.adminCousesManagement,
      ),
      endDrawer: AdminDrawer(onLogout: () => logout(context)),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CourseSearchWidget(
            controller: _searchController,
            onSubmitted: (value) {
              if (value.isEmpty) {
                _clearSearch();
              } else {
                context.read<AdminCubit>().filterCourses(value);
              }
            },
            clearSearchFunction: _clearSearch,
          ),
          Expanded(
            child: BlocConsumer<AdminCubit, AdminState>(
              listener: (context, state) {
                if (state is AdminError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is AdminCoursesLoaded) {
                  return CourseGrid(courses: state.courses);
                } else if (state is AdminLoading) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                          height: 130, width: 130, child: LottieLoading()),
                      IconButton(
                          onPressed: () {
                            context.read<AdminCubit>().getCourses();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.deepOrange,
                          ))
                    ],
                  ));
                } else {
                  return   Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                          height: 130, width: 130, child: LottieLoading()),
                      IconButton(
                          onPressed: () {
                            context.read<AdminCubit>().getCourses();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.deepOrange,
                          ))
                    ],
                  ));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Dialogs.showAddEditCourseDialog(context),
        child: LottieBuilder.asset('lib/assets/jsons/animation/add.json'),
      ),
    );
  }
}
