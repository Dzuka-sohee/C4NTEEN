import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class KeranjangController extends GetxController {
  // Observable cart items
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  // Currency formatter
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    // Load cart items from storage or previous state
    _loadCartItems();
  }

  // Load cart items (you can implement from local storage)
  void _loadCartItems() {
    // TODO: Load from local storage or Get.arguments
    // For now, empty cart
  }

  // Get total items count
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  // Get total price
  int get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }

  // Get formatted total price
  String get totalPriceFormatted {
    return currencyFormatter.format(totalPrice);
  }

  // Add item to cart
  void addItem(Map<String, dynamic> item) {
    // Check if item already exists
    final existingIndex = cartItems.indexWhere(
      (cartItem) => cartItem['id'] == item['id'] && cartItem['notes'] == item['notes'],
    );

    if (existingIndex != -1) {
      // Update quantity
      cartItems[existingIndex]['quantity'] += item['quantity'];
      cartItems[existingIndex]['subtotalFormatted'] = currencyFormatter.format(
        cartItems[existingIndex]['price'] * cartItems[existingIndex]['quantity'],
      );
    } else {
      // Add new item
      final newItem = Map<String, dynamic>.from(item);
      newItem['subtotalFormatted'] = currencyFormatter.format(
        newItem['price'] * newItem['quantity'],
      );
      cartItems.add(newItem);
    }

    update();
    Get.snackbar(
      'Berhasil',
      '${item['name']} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Remove item from cart
  void removeFromCart(String itemId) {
    Get.defaultDialog(
      title: 'Hapus Item',
      middleText: 'Apakah Anda yakin ingin menghapus item ini?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        cartItems.removeWhere((item) => item['id'] == itemId);
        update();
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Item dihapus dari keranjang',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  // Increment item quantity
  void incrementQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      final item = cartItems[index];
      if (item['quantity'] < item['stock']) {
        item['quantity']++;
        item['subtotalFormatted'] = currencyFormatter.format(
          item['price'] * item['quantity'],
        );
        cartItems[index] = item;
        update();
      } else {
        Get.snackbar(
          'Perhatian',
          'Stok tidak mencukupi',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  // Decrement item quantity
  void decrementQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      final item = cartItems[index];
      if (item['quantity'] > 1) {
        item['quantity']--;
        item['subtotalFormatted'] = currencyFormatter.format(
          item['price'] * item['quantity'],
        );
        cartItems[index] = item;
        update();
      }
    }
  }

  // Clear all cart items
  void clearCart() {
    Get.defaultDialog(
      title: 'Hapus Semua',
      middleText: 'Apakah Anda yakin ingin menghapus semua item?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        cartItems.clear();
        update();
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Semua item dihapus',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  // Proceed to checkout
  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Keranjang masih kosong',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // TODO: Navigate to checkout page
    Get.snackbar(
      'Info',
      'Fitur checkout akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
