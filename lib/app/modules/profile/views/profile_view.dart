import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller ter-inisialisasi
    final ProfileController c = Get.put(ProfileController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFECC0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile Header dengan foto dan tombol edit
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Foto profil di atas card
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://ui-avatars.com/api/?name=Yuka&background=EB9CA0&color=fff&size=200',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEB9CA0),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Color(0xFFEB9CA0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Card pink di bawah foto
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 45,
                          bottom: 25,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEB9CA0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Yuka',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 0),
              
              // Info Saldo
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pengeluaran',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Rp 150.000',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEB9CA0),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: controller.topUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB9CA0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Riwayat'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Menu Items
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Menu Favorit',
                      onTap: controller.goToFavorites,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profil',
                      onTap: controller.goToEditProfile,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifikasi',
                      onTap: controller.goToNotifications,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Bantuan & Dukungan',
                      onTap: controller.goToHelp,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: controller.goToAbout,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: controller.logout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Version
              Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECC0).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFEB9CA0),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 60,
      endIndent: 20,
    );
  }
}