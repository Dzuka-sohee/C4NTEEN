import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final employeeIdController = TextEditingController();
  
  // Observable variables
  var isLoading = false.obs;
  var profileImageUrl = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    employeeIdController.dispose();
    super.onClose();
  }
  
  /// Load data user dari Firebase
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // Set email dari Firebase Auth
        emailController.text = currentUser.email ?? '';
        
        // Get data dari Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          
          nameController.text = userData['username'] ?? currentUser.displayName ?? '';
          phoneController.text = userData['phone'] ?? '';
          employeeIdController.text = userData['employeeId'] ?? currentUser.uid.substring(0, 8).toUpperCase();
          
          // Set profile image URL
          if (userData['photoURL'] != null && userData['photoURL'].isNotEmpty) {
            profileImageUrl.value = userData['photoURL'];
          } else {
            // Generate UI Avatar jika tidak ada foto
            profileImageUrl.value = 'https://ui-avatars.com/api/?name=${nameController.text}&background=EB9CA0&color=fff&size=200';
          }
        } else {
          // Jika belum ada data di Firestore, gunakan dari Auth
          nameController.text = currentUser.displayName ?? '';
          employeeIdController.text = currentUser.uid.substring(0, 8).toUpperCase();
          profileImageUrl.value = currentUser.photoURL ?? 
              'https://ui-avatars.com/api/?name=${nameController.text}&background=EB9CA0&color=fff&size=200';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Function untuk mengubah foto profil
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFEB9CA0)),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Foto'),
              onTap: () {
                Get.back();
                _deleteProfilePhoto();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  /// Pick image dari kamera atau galeri
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        isLoading.value = true;
        
        // Upload ke Firebase Storage
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          // Create reference
          final ref = _storage.ref().child('profile_images/${currentUser.uid}.jpg');
          
          // Upload file
          await ref.putFile(File(image.path));
          
          // Get download URL
          final downloadURL = await ref.getDownloadURL();
          
          // Update Firestore
          await _firestore.collection('users').doc(currentUser.uid).update({
            'photoURL': downloadURL,
          });
          
          // Update Auth profile
          await currentUser.updatePhotoURL(downloadURL);
          
          // Update local state
          profileImageUrl.value = downloadURL;
          
          Get.snackbar(
            'Berhasil',
            'Foto profil berhasil diperbarui',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload foto: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Hapus foto profil
  Future<void> _deleteProfilePhoto() async {
    try {
      isLoading.value = true;
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // Hapus dari Storage (jika ada)
        try {
          final ref = _storage.ref().child('profile_images/${currentUser.uid}.jpg');
          await ref.delete();
        } catch (e) {
          // Ignore jika file tidak ada
          print('No profile image to delete: $e');
        }
        
        // Generate UI Avatar baru
        String defaultAvatar = 'https://ui-avatars.com/api/?name=${nameController.text}&background=cccccc&color=fff&size=200';
        
        // Update Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'photoURL': defaultAvatar,
        });
        
        // Update Auth profile
        await currentUser.updatePhotoURL(defaultAvatar);
        
        // Update local state
        profileImageUrl.value = defaultAvatar;
        
        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil dihapus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus foto: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Function untuk menyimpan perubahan profil
  Future<void> saveProfile() async {
    // Validasi
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor telepon tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // Update display name di Auth
        await currentUser.updateDisplayName(nameController.text);
        
        // Update email jika berbeda (memerlukan re-authentication)
        if (currentUser.email != emailController.text) {
          // Untuk mengubah email, user perlu login ulang
          // Ini contoh sederhana, di production sebaiknya ada re-authentication
          try {
            await currentUser.updateEmail(emailController.text);
          } catch (e) {
            Get.snackbar(
              'Error',
              'Gagal mengubah email. Silakan login ulang dan coba lagi.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        }
        
        // Update data di Firestore
        await _firestore.collection('users').doc(currentUser.uid).set({
          'username': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'employeeId': employeeIdController.text,
          'photoURL': profileImageUrl.value,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Kembali ke halaman sebelumnya
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan profil: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Function untuk mengubah password
  void changePassword() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    var isPasswordVisible1 = false.obs;
    var isPasswordVisible2 = false.obs;
    var isPasswordVisible3 = false.obs;
    
    Get.dialog(
      AlertDialog(
        title: const Text('Ubah Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => TextField(
                controller: oldPasswordController,
                obscureText: !isPasswordVisible1.value,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible1.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => isPasswordVisible1.value = !isPasswordVisible1.value,
                  ),
                ),
              )),
              const SizedBox(height: 15),
              Obx(() => TextField(
                controller: newPasswordController,
                obscureText: !isPasswordVisible2.value,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible2.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => isPasswordVisible2.value = !isPasswordVisible2.value,
                  ),
                ),
              )),
              const SizedBox(height: 15),
              Obx(() => TextField(
                controller: confirmPasswordController,
                obscureText: !isPasswordVisible3.value,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible3.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => isPasswordVisible3.value = !isPasswordVisible3.value,
                  ),
                ),
              )),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              oldPasswordController.dispose();
              newPasswordController.dispose();
              confirmPasswordController.dispose();
              Get.back();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updatePassword(
                oldPasswordController.text,
                newPasswordController.text,
                confirmPasswordController.text,
              );
              oldPasswordController.dispose();
              newPasswordController.dispose();
              confirmPasswordController.dispose();
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
  
  /// Update password di Firebase
  Future<void> _updatePassword(String oldPassword, String newPassword, String confirmPassword) async {
    // Validasi
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    if (newPassword.length < 6) {
      Get.snackbar(
        'Error',
        'Password baru minimal 6 karakter',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password baru tidak cocok',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null && currentUser.email != null) {
        // Re-authenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: oldPassword,
        );
        
        await currentUser.reauthenticateWithCredential(credential);
        
        // Update password
        await currentUser.updatePassword(newPassword);
        
        Get.back(); // Close dialog
        
        Get.snackbar(
          'Berhasil',
          'Password berhasil diubah',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Gagal mengubah password';
      
      if (e.code == 'wrong-password') {
        errorMessage = 'Password lama salah';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Silakan login ulang dan coba lagi';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }
}