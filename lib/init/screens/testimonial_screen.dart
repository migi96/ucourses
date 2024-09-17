import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import for SmoothPageIndicator
import 'package:ucourses/core/constants/app_text.dart';
import '../widgets/testimonial_item.dart';
import '../widgets/widget_exports.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key});

  @override
  _TestimonialsScreenState createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<Testimonial> testimonials = [
    Testimonial(
      icon: Icons.person,
      name: AppTexts.testimonialNameOne,
      major: 'طالب علوم تقنية',
      testimonial: AppTexts.testimonialOne,
    ),
    Testimonial(
      icon: Icons.person,
      name: AppTexts.testimonialNameTwo,
      major: 'طالب علوم حاسب الي',
      testimonial: AppTexts.testimonialThree,
    ),
    Testimonial(
      icon: Icons.person,
      name: AppTexts.testimonialNameThree,
      major: 'طالب ميكانيكا',
      testimonial: AppTexts.testimonialTwo,
    ),
  ];

  int _currentIndex = 0; // To track the current page index

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1,
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                pauseAutoPlayOnTouch: true,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemCount: testimonials.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final testimonial = testimonials[index];
                switch (index) {
                  case 0:
                    return TestimonialCardDesignOne(testimonial: testimonial);
                  case 1:
                    return TestimonialCardDesignTwo(testimonial: testimonial);
                  case 2:
                  default:
                    return TestimonialCardDesignThree(testimonial: testimonial);
                }
              },
            ),
            const SizedBox(height: 20),

            // Smooth Page Indicator
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: testimonials.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.greenAccent,
                dotColor: Colors.grey,
              ),
            ),
          ],
        ),

        // Centered Floating Action Buttons for manual navigation
        Positioned(
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: 'prev',
                onPressed: () {
                  _carouselController.previousPage();
                },
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              const SizedBox(width: 200),
              FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: 'next',
                onPressed: () {
                  _carouselController.nextPage();
                },
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
