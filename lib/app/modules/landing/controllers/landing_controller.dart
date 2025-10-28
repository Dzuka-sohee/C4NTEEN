import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class LandingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables dari Firebase
  final userName = 'Loading...'.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final totalExpense = 'Rp 0'.obs;
  final totalOrders = 0.obs;
  final totalReturned = 0.obs;
  final totalCancelled = 0.obs;
  
  var isLoading = true.obs;

  // Categories (static data)
  final categories = [
    {
      'name': 'Mie',
      'image': 'https://via.placeholder.com/60/FFD700/000000?text=Mie'
    },
    {
      'name': 'Minuman',
      'image': 'https://via.placeholder.com/60/FFA500/000000?text=Minum'
    },
    {
      'name': 'Snack',
      'image': 'https://via.placeholder.com/60/FF6347/000000?text=Snack'
    },
    {
      'name': 'Dessert',
      'image': 'https://via.placeholder.com/60/9370DB/FFFFFF?text=Dessert'
    },
  ];

  // Menu items (static data - bisa diambil dari Firestore juga)
  final menuItems = [
    {
      'id': 1,
      'image': 'assets/images/esteh.png',
      'name': 'Es Teh Sueger',
      'price': 5000,
      'priceFormatted': 'Rp 5.000,00',
      'category': 'Minuman',
      'available': true,
      'description': 'Es teh manis segar yang menyegarkan tenggorokan',
      'stock': 50
    },
    {
      'id': 2,
      'image': 'assets/images/pastel.png',
      'name': 'Pastel',
      'price': 3500,
      'priceFormatted': 'Rp 3.500,00',
      'category': 'Snack',
      'available': true,
      'description': 'Pastel isi sayur dengan kulit yang renyah',
      'stock': 30
    },
    {
      'id': 3,
      'image': 'assets/images/ayamgeprek.png',
      'name': 'Nasi Goreng',
      'price': 12000,
      'priceFormatted': 'Rp 12.000,00',
      'category': 'Nasi',
      'available': true,
      'description': 'Nasi goreng spesial dengan telur dan kerupuk',
      'stock': 25
    },
    {
      'id': 4,
      'image': 'assets/images/mieayam.png',
      'name': 'Rendang',
      'price': 25000,
      'priceFormatted': 'Rp 25.000,00',
      'category': 'Nasi',
      'available': true,
      'description': 'Rendang daging sapi empuk dengan bumbu rempah',
      'stock': 15
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load data user dari Firebase
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        // Jika tidak ada user yang login, redirect ke login
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Set email dari Firebase Auth
      userEmail.value = currentUser.email ?? '';

      // Get data dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
        // Update data user
        userName.value = userData['username'] ?? currentUser.displayName ?? 'User';
        userPhone.value = userData['phone'] ?? '';
        
        // Load data transaksi (jika ada)
        // Uncomment jika sudah punya collection orders
        // await loadTransactionData(currentUser.uid);
      } else {
        // Jika data tidak ada di Firestore, gunakan dari Auth
        userName.value = currentUser.displayName ?? 'User';
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data user',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Load data transaksi dari Firestore (opsional)
  Future<void> loadTransactionData(String userId) async {
    try {
      // Query orders collection untuk user ini
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      if (ordersSnapshot.docs.isNotEmpty) {
        int total = 0;
        int orders = 0;
        int returned = 0;
        int cancelled = 0;

        for (var doc in ordersSnapshot.docs) {
          Map<String, dynamic> order = doc.data() as Map<String, dynamic>;
          
          orders++;
          total += (order['totalPrice'] ?? 0) as int;

          String status = order['status'] ?? '';
          if (status == 'returned') returned++;
          if (status == 'cancelled') cancelled++;
        }

        // Update observable
        totalOrders.value = orders;
        totalReturned.value = returned;
        totalCancelled.value = cancelled;
        totalExpense.value = 'Rp ${_formatRupiah(total)}';
      }
    } catch (e) {
      print('Error loading transaction data: $e');
    }
  }

  /// Format angka ke format Rupiah
  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Refresh data
  Future<void> refreshData() async {
    await loadUserData();
  }

  void onNotificationPressed() {
    Get.toNamed(Routes.NOTIFICATIONS);
    // Get.snackbar('Notifikasi', 'Belum ada notifikasi baru');
  }

  void onOrderPressed(int index) async {
    // Navigate to detail menu
    final result = await Get.toNamed('/menu-detail', arguments: menuItems[index]);
    
    // Handle result from detail page (if item added to cart)
    if (result != null) {
      print('Item added to cart: $result');
      // Refresh data jika ada perubahan
      await refreshData();
    }
  }

  void onSeeAllPressed() {
    Get.toNamed('/menu');
  }
}