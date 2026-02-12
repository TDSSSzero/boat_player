import 'package:flutter/material.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/home/bg.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
      ),
    );
  }
}
