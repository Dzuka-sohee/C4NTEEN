import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observable variables
  var userName = 'User'.obs;
  var userEmail = ''.obs;
  var userRole = 'Karyawan'.obs;
  var balance = 0.obs;
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load data user dari Firebase
  Future<void> loadUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // Set email dari Firebase Auth
        userEmail.value = currentUser.email ?? '';
        
        // Get data dari Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          userName.value = userData['username'] ?? currentUser.displayName ?? 'User';
          userRole.value = userData['role'] ?? 'Karyawan';
          balance.value = userData['balance'] ?? 0;
        } else {
          // Jika belum ada data di Firestore, gunakan dari Auth
          userName.value = currentUser.displayName ?? 'User';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data user: $e',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }
  
  /// Logout function dengan Firebase (Revised - Handle Google Sign-In Error)
  Future<void> logout() async {
    // Tampilkan dialog konfirmasi
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Tutup dialog
              
              isLoading.value = true;
              
              try {
                // Logout dari Google (jika login dengan Google)
                // Dibungkus try-catch untuk handle error jika tidak login dengan Google
                try {
                  await _googleSignIn.signOut();
                } catch (e) {
                  // Ignore jika tidak login dengan Google atau ada error
                  print('Google Sign-Out skipped: $e');
                }
                
                // Logout dari Firebase
                await _auth.signOut();
                
                // Reset data
                userName.value = 'User';
                userEmail.value = '';
                userRole.value = 'Karyawan';
                balance.value = 0;
                
                Get.snackbar(
                  'Berhasil',
                  'Logout berhasil',
                  backgroundColor: Colors.green[400],
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                
                // Navigasi ke login dan hapus semua riwayat navigasi
                Get.offAllNamed(Routes.LOGIN);
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Gagal logout: $e',
                  backgroundColor: Colors.red[400],
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  
  /// Function untuk top up saldo
  void topUp() {
    final TextEditingController amountController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Top Up Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan jumlah saldo yang ingin ditambahkan:'),
            const SizedBox(height: 15),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '50000',
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              amountController.dispose();
              Get.back();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Masukkan jumlah saldo',
                  backgroundColor: Colors.red[400],
                  colorText: Colors.white,
                );
                return;
              }
              
              try {
                int amount = int.parse(amountController.text);
                
                // Update balance di Firestore
                User? currentUser = _auth.currentUser;
                if (currentUser != null) {
                  await _firestore
                      .collection('users')
                      .doc(currentUser.uid)
                      .update({
                    'balance': FieldValue.increment(amount),
                  });
                  
                  // Update local state
                  balance.value += amount;
                }
                
                amountController.dispose();
                Get.back();
                
                Get.snackbar(
                  'Berhasil',
                  'Saldo berhasil ditambahkan',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Gagal top up: $e',
                  backgroundColor: Colors.red[400],
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB9CA0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
  }
  
  // Function untuk navigasi ke halaman lain
  void goToTransactionHistory() {
    // Get.toNamed(Routes.TRANSACTION_HISTORY);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Riwayat Transaksi belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToFavorites() {
    Get.toNamed(Routes.FAVORITES);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Menu Favorit belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Edit Profil belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATIONS);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Notifikasi belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToHelp() {
    Get.toNamed(Routes.HELP);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Bantuan & Dukungan belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToAbout() {
    Get.toNamed(Routes.ABOUT);
    // Get.snackbar(
    //   'Info',
    //   'Halaman Tentang Aplikasi belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}