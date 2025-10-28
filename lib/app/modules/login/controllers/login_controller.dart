import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController usernameController;
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
    passwordController = TextEditingController();
    
    // Cek apakah user sudah login
    checkAuthStatus();
  }

  void checkAuthStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      // User sudah login, langsung ke halaman utama
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.MAIN);
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> login() async {
    // Validasi input
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password harus diisi',
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

    isLoading.value = true;

    try {
      // Login dengan Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Ambil data user dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Update username controller jika diperlukan
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        usernameController.text = userData['username'] ?? '';
      }

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Login berhasil!',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );

      // Ke halaman utama
      Get.offAllNamed(Routes.MAIN);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'user-disabled':
          errorMessage = 'Akun telah dinonaktifkan';
          break;
        case 'too-many-requests':
          errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        case 'invalid-credential':
          errorMessage = 'Email atau password salah';
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

  Future<void> loginWithGoogle() async {
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

      // Cek apakah user sudah ada di Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User baru dari Google, simpan data
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
        'Login dengan Google berhasil!',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );

      // Ke halaman utama
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal login dengan Google: $e',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
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