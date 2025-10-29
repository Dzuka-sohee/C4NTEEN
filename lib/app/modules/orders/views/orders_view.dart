import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(224, 236, 246, 247),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Tab Bar
            _buildTabBar(),

            // Order List
            Expanded(
              child: Obx(() => _buildOrderList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00A9FF)),
            onPressed: () => Get.back(),
          ),
          const Text(
            'Pesanan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00A9FF),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF00A9FF)),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(() {
        final selectedIndex = controller.selectedTab.value;
        final tabs = ['Active', 'Completed', 'Cancelled'];

        return Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF00A9FF), width: 1.5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // Smooth animated background indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                alignment: selectedIndex == 0
                    ? Alignment.centerLeft
                    : selectedIndex == 1
                        ? Alignment.center
                        : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 1 / tabs.length,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A9FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // Tab labels
              Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF00A9FF),
                          ),
                          child: Text(tabs[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A9FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF00A9FF),
              width: 1.5,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF00A9FF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    List<OrderItem> orders;

    switch (controller.selectedTab.value) {
      case 0:
        orders = controller.activeOrders;
        break;
      case 1:
        orders = controller.completedOrders;
        break;
      case 2:
        orders = controller.cancelledOrders;
        break;
      default:
        orders = [];
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada pesanan',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF89CFF3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_cafe,
                        size: 40,
                        color: Colors.brown,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Order Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 14,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.stand,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Status Buttons based on tab
                    _buildStatusButtons(order),
                  ],
                ),
              ),
            ],
          ),

          // Reminder for Active orders
          if (controller.selectedTab.value == 0 && order.reminderTime != null)
            _buildReminderSection(order),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(OrderItem order) {
    if (controller.selectedTab.value == 0) {
      // Active tab - show Take Away button
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00A9FF)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Take Away',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF00A9FF),
          ),
        ),
      );
    } else if (controller.selectedTab.value == 1) {
      // Completed tab - show Pick Up and Review buttons
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00A9FF)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Pick Up',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF00A9FF),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => controller.reviewOrder(order.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00A9FF)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Review',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00A9FF),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Cancelled tab - show Cancelled badge
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF00A9FF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Cancelled',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget _buildReminderSection(OrderItem order) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reminds me ${order.reminderTime} later',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Obx(() => Switch(
                value: controller.reminderEnabled.value,
                onChanged: controller.toggleReminder,
                activeColor: const Color(0xFF00A9FF),
                activeTrackColor: const Color(0xFF00A9FF).withOpacity(0.5),
              )),
        ],
      ),
    );
  }
}
