import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(224, 236, 246, 247),
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Logo dan judul
          Image.asset(
            'assets/images/Logo C4NTEEN.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10),
          // const Text(
          //   'C4NTEEN',
          //   style: TextStyle(
          //     fontFamily: 'Baloo 2',
          //     fontWeight: FontWeight.bold,
          //     fontSize: 22,
          //     color: Color(0xFF00A9FF),
          //   ),
          // ),
          const SizedBox(height: 20),

          // Spacer kecil agar jarak seimbang antara logo dan form
          const Spacer(),

          // FORM BOX – 72% tinggi layar
          Container(
            height: screenHeight * 0.72,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF00A9FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -3),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Daftar",
                    style: TextStyle(
                      fontFamily: 'Baloo 2',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email
                  _buildInputField(controller.emailController, hint: "Email"),
                  const SizedBox(height: 20),

                  // Username
                  _buildInputField(controller.usernameController, hint: "Username"),
                  const SizedBox(height: 20),

                  // Phone
                  _buildInputField(
                    controller.phoneController,
                    hint: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  Obx(
                    () => _buildInputField(
                      controller.passwordController,
                      hint: "Password",
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Daftar
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 32, 82, 245),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black26,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontFamily: 'Baloo 2',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // teks "atau daftar dengan"
                  const Text(
                    "atau daftar dengan",
                    style: TextStyle(
                      fontFamily: 'Baloo 2',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tombol Google
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: controller.registerWithGoogle,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Google',
                            style: TextStyle(
                              fontFamily: 'Baloo 2',
                              color: Color(0xFF00A9FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Teks bawah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          fontFamily: 'Baloo 2',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goToLogin,
                        child: const Text(
                          "Masuk Disini",
                          style: TextStyle(
                            fontFamily: 'Baloo 2',
                            color: Color.fromARGB(255, 32, 82, 245),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller, {
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon,
      ),     
      style: const TextStyle(color: Colors.white),
    );
  }
}