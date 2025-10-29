import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(224, 236, 246, 247),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A9FF)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: const Color(0xFF00A9FF),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan data dari Firebase
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => CircleAvatar(
                                  backgroundImage:
                                      controller.userEmail.value.isNotEmpty
                                          ? NetworkImage(
                                              'https://ui-avatars.com/api/?name=${controller.userName.value}&background=EB9CA0&color=fff&size=100',
                                            )
                                          : const AssetImage(
                                                  'assets/images/absenn.jpg')
                                              as ImageProvider,
                                  radius: 20,
                                )),
                            const SizedBox(width: 8),
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.userName.value,
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      controller.userPhone.value.isNotEmpty
                                          ? controller.userPhone.value
                                          : controller.userEmail.value,
                                      style: textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: controller.onNotificationPressed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Total Pengeluaran dari Firebase
                    Obx(() => Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A9FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Pengeluaran",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.totalExpense.value,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildStatChip(
                                        "${controller.totalOrders.value} Pesanan",
                                        Colors.white,
                                        textTheme),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatChip(
                                        "${controller.totalReturned.value} Dikembalikan",
                                        Colors.white,
                                        textTheme),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatChip(
                                        "${controller.totalCancelled.value} Dibatalkan",
                                        Colors.white,
                                        textTheme),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),

                    // Kategori
                    Text(
                      "Kategori",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(category['image']!),
                                  radius: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category['name']!,
                                  style: textTheme.bodySmall
                                      ?.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rekomendasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rekomendasi",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.onSeeAllPressed,
                          child: Text(
                            "Lihat semua >",
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // GridView
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.menuItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.menuItems[index];
                        return _buildMenuCard(
                          context,
                          item['image'] as String,
                          item['name'] as String,
                          item['priceFormatted'] as String,
                          () => controller.onOrderPressed(index),
                          textTheme,
                        );
                      },
                    ),
                    const SizedBox(height: 80), // Extra space untuk bottom nav
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatChip(String text, Color bgColor, TextTheme textTheme) {
    return Chip(
      label: Text(
        text,
        style: textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
      backgroundColor: bgColor.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String image,
    String name,
    String price,
    VoidCallback onPressed,
    TextTheme textTheme,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.white, // ubah background jadi putih
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black, // teks putih
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          price,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.black, // teks putih
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF00A9FF), // tombol biru
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Pesan",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}