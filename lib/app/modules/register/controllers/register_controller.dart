import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<void> register() async {
    // Validasi input
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Validasi format email
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Validasi password minimal 6 karakter
    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Register user dengan Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': emailController.text.trim(),
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Registrasi berhasil! Silakan login',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );

      // Kembali ke halaman login
      Get.offNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email sudah terdaftar';
          break;
        case 'weak-password':
          errorMessage = 'Password terlalu lemah';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operasi tidak diizinkan';
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

  Future<void> registerWithGoogle() async {
    try {
      isLoading.value = true;

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User membatalkan sign in
        isLoading.value = false;
        return;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Cek apakah user baru atau sudah ada
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User baru, simpan data ke Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'username': userCredential.user!.displayName ?? 'User',
          'phone': userCredential.user!.phoneNumber ?? '',
          'photoURL': userCredential.user!.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Registrasi dengan Google berhasil!',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );

      // Langsung ke halaman utama
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal registrasi dengan Google: $e',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
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