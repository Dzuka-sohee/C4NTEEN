// splash_controller.dart (UPDATED)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
    _navigateToWelcome();
  }

  @override
  void onReady() {
    super.onReady();
    // Reset animasi setiap kali controller ready (termasuk hot restart)
    animationController.reset();
    animationController.forward();
  }

  void _initAnimation() {
    // Setup animation controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Setup scale animation dengan curve elastic untuk efek pop up
    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Mulai animasi
    animationController.forward();
  }

  void _navigateToWelcome() {
    // Navigasi ke halaman welcome setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.WELCOME);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}