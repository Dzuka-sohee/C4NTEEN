import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(224, 236, 246, 247),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/images/Logo C4NTEEN.png',
                fit: BoxFit.contain,
              ),
            ),
            // Welcome Text
            // const Text(
            //   'C4NTEEN',
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF00A9FF),
            //     fontFamily: 'Baloo 2',
            //   ),
            // ),
            const SizedBox(height: 12),
            const Text(
              'Selamat Datang di\nC4NTEEN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF00A9FF),
                fontFamily: 'Baloo 2',
              ),
            ),
            const SizedBox(height: 50),
            // Login Button
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.goToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A9FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Baloo 2',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Register Button
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.goToRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A9FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Baloo 2',
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