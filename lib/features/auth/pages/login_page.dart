import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Light Luxury Theme Constants
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _bgPage = const Color(0xFFF9F5F0); // Cream / Off-White
  final Color _bgCard = const Color(0xFFFFFFFF); // Pure White
  final Color _textPrimary = const Color(0xFF4A3B32); // Dark Coffee Brown
  final Color _textSecondary = const Color(0xFF8D7B68); // Lighter Brown/Grey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background (Solid Cream)
          Container(color: _bgPage),

          // 2. Abstract Pattern (Dark Coffee Lines - Very Subtle)
          CustomPaint(
            painter: BackgroundPatternPainter(
              color: _textPrimary.withValues(alpha: 0.05),
            ),
            child: Container(),
          ),

          // 3. Main Content (Card)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20), // Slightly reduced from 24
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The Main Card
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black12,
                    color: _bgCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                      ), // Compact width
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ), // Compact padding
                      child: Column(
                        children: [
                          // 1. Logo Section
                          Container(
                            height: 90, // Reduced from 120
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _goldPrimary.withValues(alpha: 0.15),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: _textSecondary,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Brand Text
                          Text(
                            'TAPAL KUDA',
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 24, // Slightly smaller
                              fontWeight: FontWeight.w800,
                              color: _textPrimary,
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'PREMIUM ROASTERY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _goldPrimary,
                              letterSpacing: 4.0,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32), // Compact spacing
                          // 2. Login Form Section
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Username
                                _buildLightField(
                                  controller: _usernameController,
                                  label: 'Username',
                                  icon: Icons.person_outline_rounded,
                                  validator: (val) => (val?.isEmpty ?? true)
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 16), // Compact spacing
                                // Password
                                _buildLightField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  isPassword: true,
                                  isObscure: _obscurePassword,
                                  onToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  validator: (val) => (val?.isEmpty ?? true)
                                      ? 'Required'
                                      : null,
                                ),

                                const SizedBox(height: 8),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: _textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24), // Compact spacing
                                // Login Button
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/home',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _goldPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    shadowColor: _goldPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24), // Compact spacing
                                // Register Link
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "New here? ",
                                      style: TextStyle(
                                        color: _textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Create an account',
                                        style: TextStyle(
                                          color: _textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom Copyright
                  Text(
                    '© 2025 Tapal Kuda Coffee',
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.6),
                      fontSize: 11,
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

  Widget _buildLightField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool? isObscure,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure ?? false,
      style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: _textSecondary, size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure!
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _textSecondary,
                  size: 22,
                ),
                onPressed: onToggle,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F5F5), // Light Grey Fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _goldPrimary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ), // Reduced vertical padding
      ),
    );
  }
}

// Reuse Painter but with adjustable color
class BackgroundPatternPainter extends CustomPainter {
  final Color color;
  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    var path = Path();

    // Abstract curve 1
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.8,
    );

    // Abstract curve 2 (inverted)
    path.moveTo(size.width, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      0,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);

    // Add golden circles pattern (Solid fill this time for visibility on light)
    var goldPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      60,
      goldPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.85),
      100,
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
