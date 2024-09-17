import 'package:flutter/material.dart';
import 'dart:ui'; // Required for BackdropFilter and ImageFilter.blur
import '../../core/constants/constants_exports.dart';
import 'testimonial_item.dart';

class TestimonialCardDesignTwo extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCardDesignTwo({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen image with blurred edges
        Container(
          width: MediaQuery.of(context).size.width, // Full width
          height: MediaQuery.of(context).size.height, // Full height
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('${ImageAssets.backgroundImagePath}ai.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Blurred border effect using BackdropFilter
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0, // Blur intensity for the border
              sigmaY: 5.0,
            ),
            child: Container(
              color:
                  Colors.transparent, // Keep it transparent so the image shows
            ),
          ),
        ),

        // Slightly blurred center with text in the center
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0), // Outer padding
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.5), // Dark overlay for readability
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                    15.0), // Padding inside the outer container
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2), // Grey border
                      width: 0.7, // Border thickness
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.all(10.0), // Inner padding for content
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        testimonial.name,
                        style: Styles.style20White.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        testimonial.major,
                        style: Styles.style16White.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        testimonial.testimonial,
                        textAlign: TextAlign.center,
                        style: Styles.style14Light
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
