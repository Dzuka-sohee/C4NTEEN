import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'dart:developer';
import '../controllers/main_controller.dart';
import '../../orders/views/orders_view.dart';
import '../../landing/views/landing_view.dart';
import '../../profile/views/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const OrdersView(),
      const LandingView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: controller.notchController,
        kIconSize: 24,
        color: const Color(0xFF00A9FF),
        showLabel: false,
        notchColor: const Color(0xFF89CFF3),
        removeMargins: false,
        kBottomRadius: 12.0,
        bottomBarWidth: 500,
        durationInMilliSeconds: 500,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(Icons.receipt_long, color: Color(0xFFFFFFFF)),
            activeItem: const Icon(Icons.receipt_long, color: Color(0xFFFFFFFF)),
            itemLabel: 'Pesanan',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Icons.home_filled, color: Color(0xFFFFFFFF)),
            activeItem: const Icon(Icons.home_filled, color: Color(0xFFFFFFFF)),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Icons.person, color: Color(0xFFFFFFFF)),
            activeItem: const Icon(Icons.person, color: Color(0xFFFFFFFF)),
            itemLabel: 'Profil',
          ),
        ],
        onTap: (index) {
          log('current selected index $index');
          controller.changePage(index);
        },
      ),
    );
  }
}