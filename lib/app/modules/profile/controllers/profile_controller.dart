import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // Observable variables
  var userName = 'Yuka'.obs;
  var userRole = 'Karyawan'.obs;
  var balance = 150000.obs;
  
  // Logout function
  void logout() {
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
            onPressed: () {
              Get.back(); // Tutup dialog
              // Navigasi ke welcome page dan hapus semua riwayat navigasi
              Get.offAllNamed(Routes.WELCOME);
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
  
  // Function untuk top up saldo
  void topUp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Top Up Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan jumlah saldo yang ingin ditambahkan:'),
            const SizedBox(height: 15),
            TextField(
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
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementasi logic top up di sini
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Saldo berhasil ditambahkan',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
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
    // Get.toNamed('/transaction-history');
    Get.snackbar(
      'Info',
      'Halaman Riwayat Transaksi belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void goToFavorites() {
    Get.toNamed('/favorites');
    // Get.snackbar(
    //   'Info',
    //   'Halaman Menu Favorit belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToEditProfile() {
    Get.toNamed('/edit-profile');
    // Get.snackbar(
    //   'Info',
    //   'Halaman Edit Profil belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToNotifications() {
    Get.toNamed('/notifications');
    // Get.snackbar(
    //   'Info',
    //   'Halaman Notifikasi belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToHelp() {
    Get.toNamed('/help');
    // Get.snackbar(
    //   'Info',
    //   'Halaman Bantuan & Dukungan belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
  
  void goToAbout() {
    Get.toNamed('/about');
    // Get.snackbar(
    //   'Info',
    //   'Halaman Tentang Aplikasi belum tersedia',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}