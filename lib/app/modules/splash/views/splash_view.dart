import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      body: Center(
        child: AnimatedBuilder(
          animation: controller.scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: controller.scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset(
                'assets/images/Logo C4NTEEN.png', // Ganti dengan path logo Anda
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}