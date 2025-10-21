import 'package:get/get.dart';

class LandingController extends GetxController {
  final userName = 'Dzuka So-Hee'.obs;
  final userPhone = '0811-3118-4500'.obs;
  final totalExpense = 'Rp. 57.000,00'.obs;
  final totalOrders = 4.obs;
  final totalReturned = 0.obs;
  final totalCancelled = 0.obs;

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

  void onNotificationPressed() {
    Get.snackbar('Notifikasi', 'Belum ada notifikasi baru');
  }

  void onOrderPressed(int index) async {
    // Navigate to detail menu
    final result = await Get.toNamed('/menu-detail', arguments: menuItems[index]);
    
    // Handle result from detail page (if item added to cart)
    if (result != null) {
      // Update cart or other states if needed
      print('Item added to cart: $result');
    }
  }

  void onSeeAllPressed() {
    Get.toNamed('/menu');
  }
}