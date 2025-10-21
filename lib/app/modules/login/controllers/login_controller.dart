import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void login() {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    isLoading.value = true;
    // Simulasi login process
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offNamed(Routes.MAIN);
    });
  }

  void loginWithGoogle() {
    Get.snackbar('Info', 'Google login sedang dikembangkan');
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}