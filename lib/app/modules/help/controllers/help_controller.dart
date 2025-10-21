import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpController extends GetxController {
  // Observable variables
  var selectedCategory = 'Semua'.obs;
  var searchQuery = ''.obs;
  var expandedFaqId = ''.obs;
  
  // Text controller untuk search
  final searchController = TextEditingController();
  
  // Categories
  final categories = ['Semua', 'Pesanan', 'Pembayaran', 'Akun', 'Lainnya'];
  
  // FAQ List
  final List<FaqItem> faqs = [
    FaqItem(
      id: '1',
      category: 'Pesanan',
      question: 'Bagaimana cara memesan menu di kantin?',
      answer: 'Anda dapat memesan menu dengan cara:\n1. Browse menu yang tersedia di halaman Home\n2. Pilih menu yang diinginkan\n3. Tambahkan ke keranjang\n4. Lakukan pembayaran\n5. Tunggu pesanan siap dan ambil di counter',
    ),
    FaqItem(
      id: '2',
      category: 'Pesanan',
      question: 'Berapa lama waktu tunggu pesanan?',
      answer: 'Waktu tunggu pesanan bervariasi tergantung menu yang dipesan, biasanya:\n• Minuman: 3-5 menit\n• Snack: 5-10 menit\n• Makanan berat: 10-15 menit\n\nAnda akan mendapat notifikasi ketika pesanan sudah siap.',
    ),
    FaqItem(
      id: '3',
      category: 'Pesanan',
      question: 'Bagaimana cara membatalkan pesanan?',
      answer: 'Pembatalan pesanan dapat dilakukan sebelum pesanan diproses:\n1. Buka menu Notifikasi atau Riwayat Transaksi\n2. Pilih pesanan yang ingin dibatalkan\n3. Tap tombol "Batalkan Pesanan"\n4. Konfirmasi pembatalan\n\nSaldo akan dikembalikan ke akun Anda.',
    ),
    FaqItem(
      id: '4',
      category: 'Pembayaran',
      question: 'Bagaimana cara top up saldo?',
      answer: 'Cara top up saldo:\n1. Buka halaman Profile\n2. Tap tombol "Riwayat" pada bagian Total Pengeluaran\n3. Pilih "Top Up Saldo"\n4. Masukkan nominal yang diinginkan\n5. Lakukan pembayaran ke kasir kantin\n6. Saldo akan otomatis bertambah',
    ),
    FaqItem(
      id: '5',
      category: 'Pembayaran',
      question: 'Apakah bisa bayar dengan cash?',
      answer: 'Saat ini sistem kantin hanya menerima pembayaran melalui saldo digital di aplikasi. Anda dapat top up saldo terlebih dahulu di kasir kantin dengan cash.',
    ),
    FaqItem(
      id: '6',
      category: 'Pembayaran',
      question: 'Apakah ada minimum top up?',
      answer: 'Ya, minimum top up adalah Rp 10.000. Anda dapat top up dengan kelipatan Rp 5.000. Tidak ada batas maksimum top up.',
    ),
    FaqItem(
      id: '7',
      category: 'Akun',
      question: 'Bagaimana cara mengubah data profil?',
      answer: 'Untuk mengubah data profil:\n1. Buka halaman Profile\n2. Tap menu "Edit Profil"\n3. Ubah data yang diperlukan\n4. Tap "Simpan Perubahan"\n\nData yang dapat diubah: Nama, Email, Nomor Telepon. ID Karyawan tidak dapat diubah.',
    ),
    FaqItem(
      id: '8',
      category: 'Akun',
      question: 'Bagaimana cara mengubah password?',
      answer: 'Cara mengubah password:\n1. Buka halaman Profile\n2. Tap "Edit Profil"\n3. Tap "Ubah Password"\n4. Masukkan password lama\n5. Masukkan password baru\n6. Konfirmasi password baru\n7. Tap "Simpan"',
    ),
    FaqItem(
      id: '9',
      category: 'Akun',
      question: 'Bagaimana jika lupa password?',
      answer: 'Jika lupa password, silakan hubungi admin kantin atau bagian IT untuk reset password. Anda perlu menunjukkan ID Karyawan untuk verifikasi.',
    ),
    FaqItem(
      id: '10',
      category: 'Lainnya',
      question: 'Bagaimana cara menambahkan menu ke favorit?',
      answer: 'Untuk menambahkan menu ke favorit:\n1. Buka detail menu yang diinginkan\n2. Tap icon love (hati) di pojok kanan atas\n3. Menu akan tersimpan di halaman Menu Favorit\n\nAnda dapat mengakses Menu Favorit dari halaman Profile.',
    ),
    FaqItem(
      id: '11',
      category: 'Lainnya',
      question: 'Apakah ada promo atau diskon?',
      answer: 'Promo dan diskon akan muncul di:\n• Halaman Home (banner promo)\n• Notifikasi\n• Menu yang sedang promo akan diberi badge khusus\n\nPastikan notifikasi aplikasi aktif agar tidak ketinggalan promo!',
    ),
    FaqItem(
      id: '12',
      category: 'Lainnya',
      question: 'Bagaimana cara memberikan feedback atau komplain?',
      answer: 'Anda dapat memberikan feedback melalui:\n• Menu "Bantuan & Dukungan" > "Hubungi Kami"\n• Langsung datang ke kasir kantin\n• Email ke: kantin@perusahaan.com\n\nFeedback Anda sangat membantu kami meningkatkan layanan.',
    ),
  ];
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  // Filter FAQ berdasarkan kategori dan search
  List<FaqItem> get filteredFaqs {
    var result = faqs;
    
    // Filter by category
    if (selectedCategory.value != 'Semua') {
      result = result.where((faq) => faq.category == selectedCategory.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      result = result.where((faq) =>
        faq.question.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        faq.answer.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    return result;
  }
  
  // Change category
  void changeCategory(String category) {
    selectedCategory.value = category;
  }
  
  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  // Toggle FAQ expansion
  void toggleFaq(String id) {
    if (expandedFaqId.value == id) {
      expandedFaqId.value = '';
    } else {
      expandedFaqId.value = id;
    }
  }
  
  // Contact via WhatsApp
  void contactWhatsApp() {
    Get.snackbar(
      'WhatsApp',
      'Menghubungkan ke WhatsApp Admin Kantin...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Contact via Email
  void contactEmail() {
    Get.snackbar(
      'Email',
      'Membuka aplikasi email...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Contact via Phone
  void contactPhone() {
    Get.snackbar(
      'Telepon',
      'Menghubungkan ke nomor kantin...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}

// Model untuk FAQ Item
class FaqItem {
  final String id;
  final String category;
  final String question;
  final String answer;
  
  FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });
}