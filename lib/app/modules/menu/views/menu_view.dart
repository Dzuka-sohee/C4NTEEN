import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MenuPageController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFECC0),
        elevation: 0,
        title: Text(
          'Menu Kantin',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          _CartButton(controller: controller),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _SearchBar(
            controller: controller,
            textTheme: textTheme,
          ),

          // Category Filter
          _CategoryFilter(
            controller: controller,
            textTheme: textTheme,
          ),

          const SizedBox(height: 16),

          // Menu Grid
          Expanded(
            child: _MenuGrid(
              controller: controller,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Cart Button
class _CartButton extends StatelessWidget {
  final MenuPageController controller;

  const _CartButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuPageController>(
      builder: (_) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: controller.goToCart,
            ),
            if (controller.cartItemCount.value > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFE8A9B),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${controller.cartItemCount.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// Widget untuk Search Bar
class _SearchBar extends StatelessWidget {
  final MenuPageController controller;
  final TextTheme textTheme;

  const _SearchBar({
    required this.controller,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          controller.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Cari menu...',
          hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// Widget untuk Category Filter
class _CategoryFilter extends StatelessWidget {
  final MenuPageController controller;
  final TextTheme textTheme;

  const _CategoryFilter({
    required this.controller,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: GetBuilder<MenuPageController>(
        builder: (_) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              final isSelected = controller.selectedCategory.value == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => controller.selectCategory(category),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFFE8A9B),
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Widget untuk Menu Grid
class _MenuGrid extends StatelessWidget {
  final MenuPageController controller;
  final TextTheme textTheme;

  const _MenuGrid({
    required this.controller,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuPageController>(
      builder: (_) {
        final items = controller.filteredMenuItems;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Menu tidak ditemukan',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _MenuCard(
              item: item,
              textTheme: textTheme,
              onPressed: () => controller.onOrderPressed(item),
            );
          },
        );
      },
    );
  }
}

// Widget untuk Menu Card
class _MenuCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final TextTheme textTheme;
  final VoidCallback onPressed;

  const _MenuCard({
    required this.item,
    required this.textTheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = item['available'] as bool;
    final stock = item['stock'] as int;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with availability overlay and border radius
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item['image']!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: isAvailable ? null : Colors.grey,
                  colorBlendMode: isAvailable ? null : BlendMode.saturation,
                ),
              ),
              if (!isAvailable)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'HABIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Stock indicator
              if (isAvailable && stock < 10)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sisa $stock',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item['name']!,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    item['description']!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    item['priceFormatted']!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFFE8A9B),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),

                  // Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: isAvailable ? onPressed : null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(
                          color: isAvailable
                              ? Colors.black
                              : Colors.grey[400]!,
                          width: 1,
                        ),
                        foregroundColor:
                            isAvailable ? Colors.black : Colors.grey[400],
                      ),
                      child: Text(
                        isAvailable ? 'Pesan' : 'Habis',
                        style: textTheme.bodyMedium?.copyWith(
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
        ],
      ),
    );
  }
}