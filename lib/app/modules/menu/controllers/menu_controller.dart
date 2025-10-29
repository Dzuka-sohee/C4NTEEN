import 'package:get/get.dart';
import '../../keranjang/controllers/keranjang_controller.dart';

class MenuPageController extends GetxController {
  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;
  final cartItemCount = 0.obs;

  final categories = [
    'Semua',
    'Mie',
    'Minuman',
    'Snack',
    'Dessert',
    'Nasi',
  ];

  final allMenuItems = [
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
    {
      'id': 5,
      'image': 'assets/images/mieayam.png',
      'name': 'Mie Ayam',
      'price': 10000,
      'priceFormatted': 'Rp 10.000,00',
      'category': 'Mie',
      'available': true,
      'description': 'Mie ayam bakso dengan kuah kaldu ayam',
      'stock': 40
    },
    {
      'id': 6,
      'image': 'assets/images/esteh.png',
      'name': 'Es Jeruk',
      'price': 5000,
      'priceFormatted': 'Rp 5.000,00',
      'category': 'Minuman',
      'available': true,
      'description': 'Jus jeruk segar tanpa pemanis buatan',
      'stock': 45
    },
    {
      'id': 7,
      'image': 'assets/images/pastel.png',
      'name': 'Risoles',
      'price': 4000,
      'priceFormatted': 'Rp 4.000,00',
      'category': 'Snack',
      'available': true,
      'description': 'Risoles isi ragout ayam dan sayuran',
      'stock': 20
    },
    {
      'id': 8,
      'image': 'assets/images/esteh.png',
      'name': 'Puding',
      'price': 3000,
      'priceFormatted': 'Rp 3.000,00',
      'category': 'Dessert',
      'available': true,
      'description': 'Puding coklat lembut dengan vla vanilla',
      'stock': 35
    },
    {
      'id': 9,
      'image': 'assets/images/ayamgeprek.png',
      'name': 'Ayam Geprek',
      'price': 13000,
      'priceFormatted': 'Rp 13.000,00',
      'category': 'Nasi',
      'available': true,
      'description': 'Ayam geprek dengan sambal level 1-5',
      'stock': 30
    },
    {
      'id': 10,
      'image': 'assets/images/mieayam.png',
      'name': 'Mie Goreng',
      'price': 9000,
      'priceFormatted': 'Rp 9.000,00',
      'category': 'Mie',
      'available': false,
      'description': 'Mie goreng spesial dengan telur mata sapi',
      'stock': 0
    },
    {
      'id': 11,
      'image': 'assets/images/esteh.png',
      'name': 'Kopi Susu',
      'price': 6000,
      'priceFormatted': 'Rp 6.000,00',
      'category': 'Minuman',
      'available': true,
      'description': 'Kopi susu gula aren yang creamy',
      'stock': 40
    },
    {
      'id': 12,
      'image': 'assets/images/pastel.png',
      'name': 'Donat',
      'price': 3500,
      'priceFormatted': 'Rp 3.500,00',
      'category': 'Dessert',
      'available': true,
      'description': 'Donat coklat keju yang lembut',
      'stock': 25
    },
  ];

  @override
  void onInit() {
    super.onInit();
    updateCartCount();
  }

  List<Map<String, dynamic>> get filteredMenuItems {
    var items = allMenuItems.where((item) {
      final matchesCategory = selectedCategory.value == 'Semua' ||
          item['category'] == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          (item['name'] as String)
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    return items;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    update();
  }

  void goToCart() {
    // Use Routes.KERANJANG instead of string path
    Get.toNamed(Routes.KERANJANG);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  void onOrderPressed(Map<String, dynamic> item) async {
    if (item['available'] == true) {
      // Navigate to detail menu
      final result = await Get.toNamed(Routes.MENU_DETAIL, arguments: item);

      // Handle result from detail page (if item added to cart)
      if (result != null) {
        updateCartCount();
      }
    } else {
      Get.snackbar(
        'Tidak Tersedia',
        '${item['name']} sedang habis',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Update cart count from KeranjangController
  void updateCartCount() {
    try {
      if (Get.isRegistered<KeranjangController>()) {
        final keranjangController = Get.find<KeranjangController>();
        cartItemCount.value = keranjangController.totalItems;
        update();
      }
    } catch (e) {
      print('Error updating cart count: $e');
    }
  }
}

// Import Routes from app_routes
abstract class Routes {
  static const KERANJANG = '/keranjang';
  static const MENU_DETAIL = '/menu-detail';
}