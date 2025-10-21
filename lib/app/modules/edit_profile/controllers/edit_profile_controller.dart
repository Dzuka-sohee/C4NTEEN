import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final employeeIdController = TextEditingController();
  
  // Observable variables
  var isLoading = false.obs;
  var profileImageUrl = 'https://ui-avatars.com/api/?name=Yuka&background=EB9CA0&color=fff&size=200'.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi dengan data dummy
    nameController.text = 'Yuka';
    emailController.text = 'yuka@kantin.com';
    phoneController.text = '081234567890';
    employeeIdController.text = 'EMP-001';
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    employeeIdController.dispose();
    super.onClose();
  }
  
  // Function untuk mengubah foto profil
  void changeProfilePhoto() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ubah Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFEB9CA0)),
              title: const Text('Ambil Foto'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info',
                  'Fitur kamera belum tersedia',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFEB9CA0)),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info',
                  'Fitur galeri belum tersedia',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Foto'),
              onTap: () {
                Get.back();
                profileImageUrl.value = 'https://ui-avatars.com/api/?name=User&background=cccccc&color=fff&size=200';
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  // Function untuk menyimpan perubahan
  void saveProfile() {
    // Validasi
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor telepon tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Simulasi loading
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.back();
    });
  }
  
  // Function untuk mengubah password
  void changePassword() {
    Get.dialog(
      AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
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
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Password berhasil diubah',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB9CA0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}