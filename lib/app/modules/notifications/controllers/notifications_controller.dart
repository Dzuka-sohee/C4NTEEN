import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  // Observable list notifikasi
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;

  // Filter options
  var selectedFilter = 'Semua'.obs;
  final filterOptions = ['Semua', 'Pesanan', 'Promo', 'Sistem'];

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    // Data dummy notifikasi
    notifications.value = [
      NotificationItem(
        id: '1',
        type: 'Pesanan',
        title: 'Pesanan Siap Diambil',
        message: 'Pesanan #1234 sudah siap. Silakan ambil di counter kantin.',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        icon: '🍔',
      ),
      NotificationItem(
        id: '2',
        type: 'Promo',
        title: 'Promo Hari Ini!',
        message:
            'Dapatkan diskon 20% untuk semua minuman dingin hingga pukul 15:00',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        icon: '🎉',
      ),
      NotificationItem(
        id: '3',
        type: 'Pesanan',
        title: 'Pesanan Dikonfirmasi',
        message: 'Pesanan #1233 telah dikonfirmasi. Estimasi waktu 15 menit.',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        icon: '✅',
      ),
      NotificationItem(
        id: '4',
        type: 'Sistem',
        title: 'Saldo Berhasil Ditambahkan',
        message: 'Top up sebesar Rp 100.000 berhasil ditambahkan ke akun Anda.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: '💰',
      ),
      NotificationItem(
        id: '5',
        type: 'Pesanan',
        title: 'Pembayaran Berhasil',
        message: 'Pembayaran untuk pesanan #1232 sebesar Rp 25.000 berhasil.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: '💳',
      ),
      NotificationItem(
        id: '6',
        type: 'Promo',
        title: 'Menu Baru Tersedia',
        message:
            'Coba menu baru kami: Nasi Goreng Spesial dan Es Teh Manis Premium!',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: '🍽️',
      ),
      NotificationItem(
        id: '7',
        type: 'Sistem',
        title: 'Transaksi Berhasil',
        message: 'Pembelian Mie Goreng + Es Teh sebesar Rp 15.000 berhasil.',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: '✨',
      ),
      NotificationItem(
        id: '8',
        type: 'Pesanan',
        title: 'Pesanan Dibatalkan',
        message:
            'Pesanan #1231 dibatalkan. Saldo Rp 20.000 dikembalikan ke akun Anda.',
        time: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        icon: '❌',
      ),
    ];

    updateUnreadCount();
  }

  // Filter notifikasi berdasarkan tipe
  List<NotificationItem> get filteredNotifications {
    if (selectedFilter.value == 'Semua') {
      return notifications;
    }
    return notifications.where((n) => n.type == selectedFilter.value).toList();
  }

  // Update jumlah notifikasi yang belum dibaca
  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  // Tandai notifikasi sebagai sudah dibaca
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      updateUnreadCount();
    }
  }

  // Tandai semua notifikasi sebagai sudah dibaca
  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    updateUnreadCount();

    Get.snackbar(
      'Berhasil',
      'Semua notifikasi telah ditandai sebagai dibaca',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Hapus notifikasi
  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    updateUnreadCount();

    Get.snackbar(
      'Berhasil',
      'Notifikasi berhasil dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Hapus semua notifikasi
  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Semua Notifikasi'),
        content:
            const Text('Apakah Anda yakin ingin menghapus semua notifikasi?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              notifications.clear();
              updateUnreadCount();
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Semua notifikasi telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Ubah filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
}

// Model untuk Notifikasi
class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final String icon;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
  });
}
