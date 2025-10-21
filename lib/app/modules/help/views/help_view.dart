import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFECC0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Bantuan & Dukungan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          
          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Cari pertanyaan...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFFEB9CA0),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Category Filter
          const CategoryFilterWidget(),
          
          const SizedBox(height: 20),
          
          // FAQ List
          const Expanded(
            child: FaqListWidget(),
          ),
        ],
      ),
    );
  }
}

// Widget terpisah untuk Category Filter
class CategoryFilterWidget extends GetView<HelpController> {
  const CategoryFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.changeCategory(category),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEB9CA0)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

// Widget terpisah untuk FAQ List
class FaqListWidget extends GetView<HelpController> {
  const FaqListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredList = controller.filteredFaqs;
      
      if (filteredList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 15),
              Text(
                'Tidak Ada Hasil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredList.length + 1,
        itemBuilder: (context, index) {
          if (index == filteredList.length) {
            return ContactSection(controller: controller);
          }
          final faq = filteredList[index];
          return FaqItemWidget(
            key: ValueKey(faq.id),
            faq: faq,
          );
        },
      );
    });
  }
}

// Widget terpisah untuk FAQ Item
class FaqItemWidget extends GetView<HelpController> {
  final FaqItem faq;

  const FaqItemWidget({
    super.key,
    required this.faq,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.expandedFaqId.value == faq.id;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => controller.toggleFaq(faq.id),
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(faq.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        faq.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(faq.category),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        faq.question,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFEB9CA0),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      faq.answer,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pesanan':
        return const Color(0xFFEB9CA0);
      case 'Pembayaran':
        return Colors.green;
      case 'Akun':
        return Colors.blue;
      case 'Lainnya':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// Widget terpisah untuk Contact Section
class ContactSection extends StatelessWidget {
  final HelpController controller;

  const ContactSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Masih Butuh Bantuan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hubungi kami melalui',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          // Contact Buttons
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  icon: Icons.phone,
                  label: 'Telepon',
                  color: Colors.green,
                  onTap: controller.contactPhone,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.blue,
                  onTap: controller.contactEmail,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildContactButton(
            icon: Icons.chat,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: controller.contactWhatsApp,
            isFullWidth: true,
          ),
          
          const SizedBox(height: 20),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 15),
          
          // Operating Hours
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Jam Operasional: Senin - Jumat, 07:00 - 16:00',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}