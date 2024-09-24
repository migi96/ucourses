import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:ucourses/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:ucourses/features/admin/presentation/widgets/course_grid.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/shared/widgets/decorators/index.dart';
import '../../../../core/util/auth_utils.dart';
import '../../../../init/widgets/widget_exports.dart';
import '../../../../main.dart';
import '../cubit/admin_state.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../widgets/dialogs.dart'; // Import the AnimSearchBar package
// Import the AnimSearchBar package
// Import the AnimSearchBar package

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen>
    with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "recency"; // Default filter set to recency
  String _selectedTab = "all"; // Default selected tab is "all"

  @override
  void initState() {
    super.initState();
    _fetchCoursesForSelectedTab(); // Get all courses on initialization
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchCoursesForSelectedTab(); // Fetch courses when returning to this page
  }

  // Method to fetch courses based on selected tab
  void _fetchCoursesForSelectedTab() {
    switch (_selectedTab) {
      case "draft":
        context.read<AdminCubit>().getDraftCourses(); // Fetch draft courses
        break;
      case "deleted":
        context.read<AdminCubit>().getDeletedCourses(); // Fetch deleted courses
        break;
      case "all":
      default:
        context.read<AdminCubit>().getCourses(); // Fetch all courses
    }
  }

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
    _clearSearch(); // Clear search when switching tabs
    _fetchCoursesForSelectedTab(); // Fetch courses based on selected tab
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
    _fetchCoursesForSelectedTab(); // Fetch courses again based on the selected tab
  }

  void _filterCourses(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    context
        .read<AdminCubit>()
        .sortCourses(filter); // Sort courses based on the filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AdminDrawer(onLogout: () => logout(context)),
      body: GradientContainer(
        firstGradientColor: AppColors.primaryColor,
        secondGradientColor: AppColors.secondaryColor,
        myChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Dynamic Home Navigation
            HomeNavigation(
              navItems: [
                NavigationItem(
                  title: AppTexts.courses,
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_courses');
                  },
                ),
                NavigationItem(
                  title: AppTexts.studentsList,
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_students');
                  },
                ),
                NavigationItem(
                    title: AppTexts.profile,
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin_profile');
                    }),
                NavigationItem(
                  title: AppTexts.logout,
                  onPressed: () {
                    logout(context);
                  },
                ),
              ],
            ),

            Center(
              child: Text(
                AppTexts.courses,
                style: Styles.style20White.copyWith(fontSize: 30),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: MediaQuery.of(context).size.width * 0.03,
                  top: 40,
                  bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton("all", Icons.menu_book, AppTexts.allCourses),
                  _buildTabButton("draft", Icons.drafts, AppTexts.newerCourses),
                  _buildTabButton(
                      "deleted", Icons.delete, AppTexts.deletedCourses),
                ],
              ),
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: MediaQuery.of(context).size.width * 0.03,
                    top: 20,
                    bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // AnimSearchBar Implementation
                    AnimSearchBar(
                      width: MediaQuery.of(context).size.width * 0.2,
                      textController: _searchController,
                      helpText: AppTexts.searchCourse,
                      onSuffixTap: () {
                        _clearSearch(); // Clear search bar on suffix tap
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          _clearSearch();
                        } else {
                          context.read<AdminCubit>().filterCourses(value);
                        }
                      },
                    ),

                    // Divider between search and filter
                    const SizedBox(width: 16),
                    Container(
                      height: 40,
                      width: 2,
                      color: Colors.white.withOpacity(0.7),
                    ),

                    const SizedBox(width: 16),

                    // Dropdown for sorting with label
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " فلتر  : ", // Arabic label for filter
                          style: Styles.style18.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        DropdownButton<String>(
                          iconSize: 35,
                          iconEnabledColor: Colors.white,
                          focusColor: Colors.white,
                          elevation: 10,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          underline: const SizedBox(),
                          style: Styles.style18.copyWith(
                              color: Colors.black), // For dropdown items
                          icon: const Icon(Icons.filter_list,
                              color: Colors.white),
                          value: _selectedFilter,
                          items: const [
                            DropdownMenuItem(
                              value: "recency",
                              child: Text("الأحدث"),
                            ),
                            DropdownMenuItem(
                              value: "alphabetical",
                              child: Text("أبجدياً"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _filterCourses(value);
                            }
                          },
                          hint: const Text("ترتيب حسب"),

                          // Customize the selected item color using selectedItemBuilder
                          selectedItemBuilder: (BuildContext context) {
                            return <Widget>[
                              Text(
                                AppTexts.newerCourse,
                                style: Styles.style18.copyWith(
                                    color:
                                        Colors.black), // Selected item in black
                              ),
                              Text(
                                AppTexts.alphabetical,
                                style: Styles.style18.copyWith(
                                    color:
                                        Colors.black), // Selected item in black
                              ),
                            ];
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Course Grid
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
                    return CourseGrid(
                      courses: state.courses,
                      isDeletedTab:
                          _selectedTab == "deleted", // Pass isDeletedTab here
                    );
                  } else if (state is AdminLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text("لا توجد دورات متاحة"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Dialogs.showAddEditCourseDialog(context),
        child: LottieBuilder.asset('lib/assets/jsons/animation/add.json'),
      ),
    );
  }

  Widget _buildTabButton(String tab, IconData icon, String label) {
    bool isSelected = _selectedTab == tab;

    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            _selectTab(tab);
          },
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            style: Styles.style18.copyWith(color: Colors.white),
          ),
        ),
        if (isSelected)
          Container(
            height: 2,
            width: 60,
            color: Colors.white,
          ),
      ],
    );
  }
}
