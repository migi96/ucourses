import 'package:flutter/material.dart';
import '../../core/constants/constants_exports.dart';
import 'dart:ui'; // Import this to use BackdropFilter and ImageFilter.blur
import 'testimonial_item.dart';

class TestimonialCardDesignOne extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCardDesignOne({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Segment: White Container with Arabic Text and Quotes Images
        Container(
          width: MediaQuery.of(context).size.width * 0.3, // Left side 30%
          decoration: const BoxDecoration(
            color: Colors.white, // White background
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // Top-left quote image
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  '${ImageAssets.backgroundImagePath}quotes.png',
                  scale: 5,
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
              ),

              // Bottom-right flipped quote image
              Positioned(
                bottom: 0,
                right: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.rotationY(3.14159), // Flip the image horizontally
                  child: Image.asset(
                    '${ImageAssets.backgroundImagePath}quotes.png',
                    scale: 5,
                    color: AppColors.primaryColor.withOpacity(0.2),
                  ),
                ),
              ),

              // Arabic Text in the center
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تجربة طلابنا', // Title: Our students' experience
                      textAlign: TextAlign.center,
                      style: Styles.style18.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        'في منصتنا التعليمية، نؤمن بأن نجاح طلابنا هو أساس نجاحنا. نحن ملتزمون بتقديم أفضل تجربة تعليمية، حيث '
                        'نضمن لهم الوصول إلى مواد تعليمية متقدمة ومتميزة. نسعى دائمًا لدعم الطلاب وتطويرهم، '
                        'من خلال توفير البيئة المثالية لتعلم مستمر وتفاعل بناء يساعدهم على تحقيق أهدافهم الأكاديمية والمهنية.', // More meaningful and engaging text about the platform's care for students
                        textAlign: TextAlign.center,
                        style: Styles.style20White
                            .copyWith(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Center Segment: Blurred Image and Testimonial Content
        Expanded(
          child: Stack(
            children: [
              // Background image container (blur applied only here)
              ClipRect(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/assets/images/style/home-background.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
                    child: Container(
                      color: Colors.black.withOpacity(
                          0.2), // Optional dark overlay to reduce brightness
                    ),
                  ),
                ),
              ),

              // Content on top of the blurred image with space for border
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0), // Add outer padding
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.35, // Width of container with space for border
                    height: MediaQuery.of(context).size.height *
                        0.45, // Height of container
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                          0.4), // Grey background with transparency
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          15.0), // Add inner padding for the content
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2), // Black border
                            width: 0.7, // Border thickness
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(
                            10.0), // Padding inside the bordered container
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              testimonial.name,
                              style: Styles.style20White.copyWith(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              testimonial.major,
                              style: Styles.style16White.copyWith(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              testimonial.testimonial,
                              style: Styles.style14White.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
