import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart'; // Import the video player package
import 'package:flutter/material.dart';

import '../../../../core/constants/constants_exports.dart';
import '../../../../core/shared/widgets/style/lottie_loading.dart';
import '../../domain/entities/course_entity.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late PageController _pageController;
  late int _currentPage;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;

    // Initialize video player if intro video is available
    if (widget.course.introVideo != null &&
        widget.course.introVideo!.isNotEmpty) {
      _videoController =
          VideoPlayerController.network(widget.course.introVideo!)
            ..initialize().then((_) {
              setState(() {}); // Refresh the UI once the video is initialized
            });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose(); // Dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Course? course =
        ModalRoute.of(context)!.settings.arguments as Course?;

    final List<String> contentLines = widget.course.content.split('\n');
    const int linesPerPage = 10;
    final int numPages = (contentLines.length / linesPerPage).ceil();

    if (course == null) {
      return const Scaffold(
        body: Center(child: Text('Course data is missing')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(widget.course.title),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Check if there's an intro video and display it
              if (_videoController != null &&
                  _videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              if (_videoController != null &&
                  !_videoController!.value.isInitialized)
                const Center(child: CircularProgressIndicator()),

              // If no video, display the course image as fallback
              if (_videoController == null)
                Card(
                  elevation: 10,
                  child: CachedNetworkImage(
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.course.images,
                    placeholder: (context, url) => const LottieLoading(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              const Text(
                AppTexts.courseTitle,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Text(
                widget.course.title,
                style: Styles.style16,
              ),
              const SizedBox(height: 20),
              const Text(
                AppTexts.courseDescripition,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Text(
                widget.course.description,
                style: Styles.style16,
              ),
              const SizedBox(height: 20),
              const Text(
                AppTexts.courseContent,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200, // Adjust the height as needed
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: buildContentPages(contentLines, linesPerPage),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(numPages, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage == index
                                  ? AppColors.primaryColor
                                  : AppColors.fourthColor,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: Styles.style16White,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                AppTexts.courseRating,
                style: Styles.styleBold,
              ),
              const SizedBox(height: 5),
              // Rating bar and quiz logic remains the same
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildContentPages(List<String> contentLines, int linesPerPage) {
    List<Widget> pages = [];
    int numPages = (contentLines.length / linesPerPage).ceil();
    for (int i = 0; i < numPages; i++) {
      int startLine = i * linesPerPage;
      int endLine = startLine + linesPerPage;
      if (endLine > contentLines.length) endLine = contentLines.length;
      String pageContent = contentLines.sublist(startLine, endLine).join('\n');
      pages.add(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pageContent,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ));
    }
    return pages;
  }
}
