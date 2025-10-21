import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_detail_controller.dart';

class MenuDetailView extends GetView<MenuDetailController> {
  const MenuDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            slivers: [
              // Image Header with back button
              SliverAppBar(
                expandedHeight: size.height * 0.45,
                pinned: true,
                backgroundColor: const Color(0xFFFFECC0),
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
                actions: [
                  Obx(() => Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: controller.isFavorite.value
                                ? const Color(0xFFFE8A9B)
                                : Colors.black,
                          ),
                          onPressed: controller.toggleFavorite,
                        ),
                      )),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'menu-${controller.menuItem['name']}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          controller.menuItem['image']!,
                          fit: BoxFit.cover,
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFFFFECC0).withOpacity(0.9),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        // Stock or availability badge
                        if (!(controller.menuItem['available'] as bool))
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                'HABIS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFECC0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main content card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Category
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.menuItem['name']!,
                                        style: textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFE8A9B)
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          controller.menuItem['category']!,
                                          style:
                                              textTheme.bodySmall?.copyWith(
                                            color: const Color(0xFFFE8A9B),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Price and Stock in a card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFE8A9B).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Harga',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.menuItem['priceFormatted']!,
                                        style: textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFE8A9B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (controller.menuItem['available'] as bool)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFFE8A9B).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 18,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${controller.menuItem['stock']} porsi',
                                            style: textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Description
                            Text(
                              'Deskripsi',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.menuItem['description']!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity selector card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jumlah Pesanan',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(() => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFECC0).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Decrease button
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: controller.quantity.value > 1
                                          ? Colors.white
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: controller.quantity.value > 1
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: controller.quantity.value > 1
                                          ? controller.decrementQuantity
                                          : null,
                                      color: controller.quantity.value > 1
                                          ? const Color(0xFFFE8A9B)
                                          : Colors.grey[400],
                                      iconSize: 24,
                                    ),
                                  ),
                                  // Quantity display
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${controller.quantity.value}',
                                          style:
                                              textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFE8A9B),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Increase button
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: controller.quantity.value <
                                              (controller.menuItem['stock']
                                                  as int)
                                          ? Colors.white
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: controller.quantity.value <
                                              (controller.menuItem['stock']
                                                  as int)
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: controller.quantity.value <
                                              (controller.menuItem['stock']
                                                  as int)
                                          ? controller.incrementQuantity
                                          : null,
                                      color: controller.quantity.value <
                                              (controller.menuItem['stock']
                                                  as int)
                                          ? const Color(0xFFFE8A9B)
                                          : Colors.grey[400],
                                      iconSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Notes card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_note,
                                  color: Colors.grey[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Catatan (Opsional)',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              onChanged: controller.updateNotes,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Contoh: Tidak pakai cabe, tambah kerupuk',
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[400],
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFFECC0).withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFE8A9B),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // Space for buttons
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Total price card
                    Obx(() => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE8A9B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Harga',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.totalPriceFormatted,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFE8A9B),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${controller.quantity.value}x item',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        // Add to cart button
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: controller.menuItem['available'] as bool
                                    ? const Color(0xFFFE8A9B)
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: controller.menuItem['available'] as bool
                                  ? controller.addToCart
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFE8A9B),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                disabledBackgroundColor: Colors.grey[100],
                                disabledForegroundColor: Colors.grey[400],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 22,
                                    color: controller.menuItem['available'] as bool
                                        ? const Color(0xFFFE8A9B)
                                        : Colors.grey[400],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Keranjang',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Order now button
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: controller.menuItem['available'] as bool
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFE8A9B),
                                        Color(0xFFFE6B89),
                                      ],
                                    )
                                  : null,
                              boxShadow: controller.menuItem['available'] as bool
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFE8A9B)
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ElevatedButton(
                              onPressed: controller.menuItem['available'] as bool
                                  ? controller.orderNow
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pesan Sekarang',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}