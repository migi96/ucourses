import 'package:flutter/material.dart';
import '../../core/constants/constants_exports.dart';
import 'testimonial_item.dart';

class TestimonialCardDesignThree extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCardDesignThree({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen image background
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('${ImageAssets.backgroundImagePath}saudi.webp'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.06,
          child: Image.asset(
            '${ImageAssets.backgroundImagePath}quotes.png',
            scale: 5,
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          right: MediaQuery.of(context).size.width * 0.6,
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
        Positioned(
          left: 20, // Positioning the column on the right
          top: 30,
          bottom: 20, // Adjusted bottom positioning
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.45, // Increased the width
            height: MediaQuery.of(context).size.height *
                2, // Adjusted height for a balanced size
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.circular(15), // Slightly larger rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('''يهدف هذا النظام إلى تقديم الدعم للطلاب في دراستهم
          الجامعية واستعدادهم
          للامتحانات، مع تحسين تجربة المستخدم
          لتسهيل عملية التعلم وتوفير
         . الوقت والجهد''',
                    textAlign: TextAlign.center,
                    style: Styles.style20White
                        .copyWith(color: Colors.grey, fontSize: 18)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20, // Positioning the column on the right
          top: 30,
          bottom: 20, // Adjusted bottom positioning
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.45, // Increased the width
            height: MediaQuery.of(context).size.height *
                2, // Adjusted height for a balanced size
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.circular(15), // Slightly larger rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  testimonial.name,
                  textAlign: TextAlign.center,
                  style: Styles.style20White.copyWith(
                      fontSize: 28, // Slightly larger font size for the name
                      color: AppColors.primaryColor),
                ),
                const SizedBox(height: 12),
                Text(
                  testimonial.major,
                  textAlign: TextAlign.center,
                  style: Styles.style16White.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 22), // Increased font size for the major
                ),
                const SizedBox(height: 15),

                // Testimonial text
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      testimonial.testimonial,
                      textAlign: TextAlign.center,
                      style: Styles.style14Light.copyWith(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize:
                            20, // Slightly larger font size for the testimonial text
                      ),
                    ),
                  ),
                ),

                // Five stars rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 22, // Slightly larger star icons
                    );
                  }),
                ),
              ],
            ),
          ),
        )
        // Testimonial info on the right
      ],
    );
  }
}
