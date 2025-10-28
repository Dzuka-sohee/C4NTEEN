import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE97777)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: const Color(0xFFE97777),
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
                              backgroundImage: controller.userEmail.value.isNotEmpty
                                  ? NetworkImage(
                                      'https://ui-avatars.com/api/?name=${controller.userName.value}&background=EB9CA0&color=fff&size=100',
                                    )
                                  : const AssetImage('assets/images/absenn.jpg') as ImageProvider,
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFE8A9B),
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
                              const SizedBox(height: 8),
                              Text(
                                controller.totalExpense.value,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatChip(
                                      "${controller.totalOrders.value} Pesanan",
                                      Colors.white,
                                      textTheme),
                                  _buildStatChip(
                                      "${controller.totalReturned.value} Dikembalikan",
                                      Colors.white,
                                      textTheme),
                                  _buildStatChip(
                                      "${controller.totalCancelled.value} Dibatalkan",
                                      Colors.white,
                                      textTheme),
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
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(category['image']!),
                                  radius: 25,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category['name']!,
                                  style:
                                      textTheme.bodySmall?.copyWith(fontSize: 12),
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
                            style:
                                textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // GridView
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.68,
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
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[800],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    side: const BorderSide(color: Colors.black, width: 1),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    "Pesan",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}