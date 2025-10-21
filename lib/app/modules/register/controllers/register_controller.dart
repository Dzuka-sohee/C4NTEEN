import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void register() {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    isLoading.value = true;
    // Simulasi register process
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar('Success', 'Registrasi berhasil! Silakan login');
      Get.offNamed(Routes.LOGIN);
    });
  }

  void registerWithGoogle() {
    Get.snackbar('Info', 'Google registration sedang dikembangkan');
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}