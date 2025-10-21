import 'package:get/get.dart';

class OrdersController extends GetxController {
  // Current selected tab (0: Active, 1: Completed, 2: Cancelled)
  var selectedTab = 0.obs;
  
  // Observable for reminder toggle
  var reminderEnabled = true.obs;
  
  // Sample order data - replace with your actual data model
  var activeOrders = <OrderItem>[
    OrderItem(
      id: '1',
      name: 'Es Kopi Susu',
      stand: 'Stand 3',
      imageUrl: 'assets/images/coffee.png', // Sesuaikan dengan path asset Anda
      status: 'Take Away',
      reminderTime: '30 minutes',
    ),
  ].obs;
  
  var completedOrders = <OrderItem>[
    OrderItem(
      id: '2',
      name: 'Es Kopi Susu',
      stand: 'Stand 3',
      imageUrl: 'assets/images/coffee.png',
      status: 'Completed',
      hasReview: false,
    ),
  ].obs;
  
  var cancelledOrders = <OrderItem>[
    OrderItem(
      id: '3',
      name: 'Es Kopi Susu',
      stand: 'Stand 3',
      imageUrl: 'assets/images/coffee.png',
      status: 'Cancelled',
    ),
  ].obs;
  
  void changeTab(int index) {
    selectedTab.value = index;
  }
  
  void toggleReminder(bool value) {
    reminderEnabled.value = value;
  }
  
  void pickUpOrder(String orderId) {
    // Implement pick up logic
    print('Pick up order: $orderId');
  }
  
  void reviewOrder(String orderId) {
    // Implement review logic
    print('Review order: $orderId');
  }
}

// Model class untuk order item
class OrderItem {
  final String id;
  final String name;
  final String stand;
  final String imageUrl;
  final String status;
  final String? reminderTime;
  final bool? hasReview;
  
  OrderItem({
    required this.id,
    required this.name,
    required this.stand,
    required this.imageUrl,
    required this.status,
    this.reminderTime,
    this.hasReview,
  });
}