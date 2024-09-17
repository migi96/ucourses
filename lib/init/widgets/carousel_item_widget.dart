import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ucourses/init/widgets/carousel_item.dart';

import '../../core/constants/constants_exports.dart';
import '../../core/shared/widgets/decorators/index.dart';

class CarouselItemWidget extends StatelessWidget {
  final CarouselItem item;

  const CarouselItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 40, bottom: 40),
      color: Colors.transparent,
      elevation: 3,
      child: Container(
        width: 400,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GradientIcon(
                  firstGradientColor: Colors.white,
                  secondGradientColor: Colors.white,
                  myChild: Lottie.asset(
                    item.imageUrl,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.title,
                      style: Styles.style20White.copyWith(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(item.description,
                      style: Styles.style20White
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
