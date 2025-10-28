import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  late TextEditingController emailController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  /// Kirim email reset password
  Future<void> sendResetPasswordEmail() async {
    // Validasi email kosong
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email harus diisi',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Validasi format email
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Kirim email reset password
      await _auth.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      isLoading.value = false;

      // Tampilkan dialog sukses
      Get.dialog(
        AlertDialog(
          title: const Text(
            'Email Terkirim',
            style: TextStyle(fontFamily: 'Baloo 2'),
          ),
          content: Text(
            'Link reset password telah dikirim ke ${emailController.text.trim()}.\n\nSilakan cek email Anda (termasuk folder spam).',
            style: const TextStyle(fontFamily: 'Baloo 2'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
                Get.back(); // Kembali ke login
              },
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'too-many-requests':
          errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
