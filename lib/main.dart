import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generate dengan: flutterfire configure
import 'app/routes/app_pages.dart';

void main() async {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C4NTEEN',
      theme: ThemeData(
        fontFamily: 'Baloo 2',
        scaffoldBackgroundColor: const Color(0xFFFFF5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Baloo 2',
        ),
        primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Baloo 2',
        ),
        useMaterial3: true,
      ),
      // Gunakan home instead of initialRoute untuk memaksa rebuild
      home: const SplashWrapper(),
      getPages: AppPages.routes,
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    // Setiap kali widget ini dibuat (termasuk hot restart), navigasi ke splash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.SPLASH);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFECC0),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE97777)),
        ),
      ),
    );
  }
}