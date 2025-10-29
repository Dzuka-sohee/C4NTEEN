import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MenuDetailController extends GetxController {
  late Map<String, dynamic> menuItem;
  final quantity = 1.obs;
  final selectedNotes = ''.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari arguments
    menuItem = Get.arguments as Map<String, dynamic>;
  }

  void incrementQuantity() {
    if (quantity.value < (menuItem['stock'] as int)) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    Get.snackbar(
      isFavorite.value ? 'Ditambahkan' : 'Dihapus',
      isFavorite.value
          ? '${menuItem['name']} ditambahkan ke favorit'
          : '${menuItem['name']} dihapus dari favorit',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void updateNotes(String notes) {
    selectedNotes.value = notes;
  }

  int get totalPrice {
    return (menuItem['price'] as int) * quantity.value;
  }

  String get totalPriceFormatted {
    final formatter = totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatter,00';
  }

  void addToCart() {
    if (menuItem['available'] == true) {
      Get.back(result: {
        'item': menuItem,
        'quantity': quantity.value,
        'notes': selectedNotes.value,
        'totalPrice': totalPrice,
      });
      
      Get.snackbar(
        'Berhasil',
        '${quantity.value}x ${menuItem['name']} ditambahkan ke keranjang',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF00A9FF),
        colorText: Colors.white,
      );
    }
  }

  void orderNow() {
    if (menuItem['available'] == true) {
      // Navigate to checkout directly
      Get.snackbar(
        'Proses Pesanan',
        'Menuju halaman pembayaran...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      // Get.toNamed('/checkout', arguments: {...});
    }
  }
}