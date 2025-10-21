import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class MainController extends GetxController {
  late PageController pageController;
  late NotchBottomBarController notchController;
  
  final currentIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 1);
    notchController = NotchBottomBarController(index: 1);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }
}