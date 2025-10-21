import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  final String appName = 'Kantin Digital';
  final String version = '1.0.0';
  final String description = 
      'Aplikasi kantin digital yang memudahkan Anda untuk memesan makanan dan minuman di kantin perusahaan. Nikmati kemudahan transaksi cashless dan pengalaman pemesanan yang lebih cepat.';
  
  final List<Map<String, dynamic>> features = [
    {
      'icon': '🍽️',
      'title': 'Pesan Menu',
      'description': 'Pesan makanan favorit dengan mudah',
    },
    {
      'icon': '💳',
      'title': 'Cashless',
      'description': 'Transaksi tanpa uang tunai',
    },
    {
      'icon': '⚡',
      'title': 'Cepat & Praktis',
      'description': 'Hemat waktu antrean',
    },
    {
      'icon': '❤️',
      'title': 'Menu Favorit',
      'description': 'Simpan menu kesukaan Anda',
    },
  ];
  
  final List<Map<String, String>> teamInfo = [
    {
      'title': 'Email',
      'value': 'support@kantindigital.com',
      'icon': 'email',
    },
    {
      'title': 'Website',
      'value': 'www.kantindigital.com',
      'icon': 'web',
    },
    {
      'title': 'Telepon',
      'value': '+62 812-3456-7890',
      'icon': 'phone',
    },
  ];
  
  void openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@kantindigital.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka email');
    }
  }
  
  void openWebsite() async {
    Get.snackbar(
      'Info',
      'Fitur ini akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void openPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+628123456789',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka telepon');
    }
  }
  
  void showPrivacyPolicy() {
    Get.snackbar(
      'Info',
      'Kebijakan Privasi akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void showTermsOfService() {
    Get.snackbar(
      'Info',
      'Syarat & Ketentuan akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}