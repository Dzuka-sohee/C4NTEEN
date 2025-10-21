import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  // Observable list menu favorit
  var favoriteMenus = <FavoriteMenu>[].obs;
  var isLoading = false.obs;
  
  // Filter options
  var selectedCategory = 'Semua'.obs;
  final categories = ['Semua', 'Makanan', 'Minuman', 'Snack'];
  
  @override
  void onInit() {
    super.onInit();
    loadFavoriteMenus();
  }
  
  void loadFavoriteMenus() {
    isLoading.value = true;
    
    // Data dummy menu favorit
    Future.delayed(const Duration(milliseconds: 500), () {
      favoriteMenus.value = [
        FavoriteMenu(
          id: '1',
          name: 'Nasi Goreng Spesial',
          category: 'Makanan',
          price: 15000,
          image: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
          rating: 4.8,
          orderCount: 125,
          description: 'Nasi goreng dengan telur, ayam, dan sayuran segar',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '2',
          name: 'Es Teh Manis',
          category: 'Minuman',
          price: 5000,
          image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
          rating: 4.9,
          orderCount: 200,
          description: 'Es teh manis segar yang menyegarkan',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '3',
          name: 'Mie Goreng',
          category: 'Makanan',
          price: 12000,
          image: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400',
          rating: 4.7,
          orderCount: 98,
          description: 'Mie goreng pedas dengan telur dan sayuran',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '4',
          name: 'Kopi Susu',
          category: 'Minuman',
          price: 8000,
          image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
          rating: 4.6,
          orderCount: 150,
          description: 'Kopi susu dengan gula aren',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '5',
          name: 'Pisang Goreng',
          category: 'Snack',
          price: 7000,
          image: 'https://images.unsplash.com/photo-1587241636997-a9a29e21e2e0?w=400',
          rating: 4.5,
          orderCount: 80,
          description: 'Pisang goreng crispy dengan keju',
          isAvailable: false,
        ),
        FavoriteMenu(
          id: '6',
          name: 'Ayam Bakar',
          category: 'Makanan',
          price: 18000,
          image: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
          rating: 4.9,
          orderCount: 110,
          description: 'Ayam bakar dengan sambal dan lalapan',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '7',
          name: 'Jus Alpukat',
          category: 'Minuman',
          price: 10000,
          image: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400',
          rating: 4.7,
          orderCount: 90,
          description: 'Jus alpukat segar dengan susu coklat',
          isAvailable: true,
        ),
        FavoriteMenu(
          id: '8',
          name: 'Risoles',
          category: 'Snack',
          price: 6000,
          image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
          rating: 4.6,
          orderCount: 75,
          description: 'Risoles isi sayuran dan daging ayam',
          isAvailable: true,
        ),
      ];
      isLoading.value = false;
    });
  }
  
  // Filter menu berdasarkan kategori
  List<FavoriteMenu> get filteredMenus {
    if (selectedCategory.value == 'Semua') {
      return favoriteMenus;
    }
    return favoriteMenus.where((menu) => menu.category == selectedCategory.value).toList();
  }
  
  // Ubah kategori filter
  void changeCategory(String category) {
    selectedCategory.value = category;
  }
  
  // Hapus dari favorit
  void removeFromFavorites(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus dari Favorit'),
        content: const Text('Apakah Anda yakin ingin menghapus menu ini dari favorit?'),
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
              favoriteMenus.removeWhere((menu) => menu.id == id);
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Menu berhasil dihapus dari favorit',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
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
  
  // Pesan menu
  void orderMenu(FavoriteMenu menu) {
    if (!menu.isAvailable) {
      Get.snackbar(
        'Tidak Tersedia',
        'Maaf, menu ini sedang tidak tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    Get.dialog(
      AlertDialog(
        title: Text(menu.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                menu.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              menu.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Harga:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rp ${menu.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFEB9CA0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Jumlah Pesanan:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () {},
                        color: const Color(0xFFEB9CA0),
                      ),
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {},
                        color: const Color(0xFFEB9CA0),
                      ),
                    ],
                  ),
                ),
              ],
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
                '${menu.name} ditambahkan ke keranjang',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB9CA0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Pesan'),
          ),
        ],
      ),
    );
  }
  
  // Hapus semua favorit
  void clearAllFavorites() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Semua Favorit'),
        content: const Text('Apakah Anda yakin ingin menghapus semua menu favorit?'),
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
              favoriteMenus.clear();
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Semua menu favorit telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
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
}

// Model untuk Menu Favorit
class FavoriteMenu {
  final String id;
  final String name;
  final String category;
  final int price;
  final String image;
  final double rating;
  final int orderCount;
  final String description;
  final bool isAvailable;
  
  FavoriteMenu({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.orderCount,
    required this.description,
    required this.isAvailable,
  });
}