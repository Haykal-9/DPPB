import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Gender selection
  List<Gender> _genders = [];
  int? _selectedGenderId;

  // Profile picture
  XFile? _profileImage;
  Uint8List? _profileBytes;
  final ImagePicker _picker = ImagePicker();

  final AuthService _authService = AuthService();
  // Light Luxury Theme Constants (Mobile Style)
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _bgCard = const Color(0xFFFFFFFF);
  final Color _textPrimary = const Color(0xFF4A3B32);
  final Color _textSecondary = const Color(0xFF8D7B68);
  @override
  void initState() {
    super.initState();
    _loadGenders();
  }

  Future<void> _loadGenders() async {
    final genders = await _authService.getGenders();
    setState(() => _genders = genders);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = image;
        _profileBytes = bytes;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _authService.register(
      username: _usernameController.text.trim(),
      nama: _namaController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      noTelp: _phoneController.text.trim(),
      genderId: _selectedGenderId,
      alamat: _alamatController.text.trim(),
      profilePicture: _profileImage,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi gagal. Username atau email mungkin sudah digunakan.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(color: _bgPage),

          // Pattern
          CustomPaint(
            painter: BackgroundPatternPainter(
              color: _textPrimary.withValues(alpha: 0.05),
            ),
            child: Container(),
          ),

          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card
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
                      constraints: const BoxConstraints(maxWidth: 380),
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            height: 60,
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
                                  Icons.coffee,
                                  size: 40,
                                  color: _goldPrimary,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            'BUAT AKUN',
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: _textPrimary,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            'Bergabung dengan Tapal Kuda',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Nama Lengkap
                                _buildLightField(
                                  controller: _namaController,
                                  label: 'Nama Lengkap',
                                  icon: Icons.badge_outlined,
                                  validator: (val) => (val?.isEmpty ?? true)
                                      ? 'Nama wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                // Username
                                _buildLightField(
                                  controller: _usernameController,
                                  label: 'Username',
                                  icon: Icons.person_outline,
                                  validator: (val) => (val?.isEmpty ?? true)
                                      ? 'Username wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                // Email
                                _buildLightField(
                                  controller: _emailController,
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val?.isEmpty ?? true)
                                      return 'Email wajib diisi';
                                    if (!val!.contains('@'))
                                      return 'Email tidak valid';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                // Password
                                _buildLightField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  isObscure: _obscurePassword,
                                  onToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  validator: (val) {
                                    if (val?.isEmpty ?? true)
                                      return 'Password wajib diisi';
                                    if (val!.length < 6)
                                      return 'Minimal 6 karakter';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                // Konfirmasi Password
                                _buildLightField(
                                  controller: _confirmPasswordController,
                                  label: 'Konfirmasi Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  isObscure: _obscureConfirmPassword,
                                  onToggle: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                  validator: (val) {
                                    if (val?.isEmpty ?? true)
                                      return 'Konfirmasi password wajib diisi';
                                    if (val != _passwordController.text)
                                      return 'Password tidak sama';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                // No Telepon
                                _buildLightField(
                                  controller: _phoneController,
                                  label: 'No. Telepon',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 14),

                                // Jenis Kelamin
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.wc_outlined,
                                        color: _textSecondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Jenis Kelamin',
                                          style: TextStyle(
                                            color: _textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      _buildGenderChip('L', 1),
                                      const SizedBox(width: 8),
                                      _buildGenderChip('P', 2),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Alamat
                                _buildLightField(
                                  controller: _alamatController,
                                  label: 'Alamat Lengkap',
                                  icon: Icons.location_on_outlined,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 14),

                                // Foto Profil
                                Text(
                                  'Foto Profil',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _goldPrimary.withValues(
                                          alpha: 0.3,
                                        ),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: _profileBytes != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.memory(
                                              _profileBytes!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                color: _goldPrimary,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Klik untuk upload foto',
                                                style: TextStyle(
                                                  color: _textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Register Button
                                ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _goldPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    shadowColor: _goldPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'DAFTAR',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 16),

                                // Login Link
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Sudah punya akun? ",
                                      style: TextStyle(
                                        color: _textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        'Masuk di sini',
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
                  const SizedBox(height: 16),
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

  Widget _buildGenderChip(String label, int value) {
    bool isSelected = _selectedGenderId == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGenderId = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _goldPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? _goldPrimary
                : _textSecondary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _goldPrimary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
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
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure ?? false,
      keyboardType: keyboardType,
      maxLines: isPassword ? 1 : maxLines,
      style: TextStyle(
        color: _textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _textSecondary, fontSize: 12),
        prefixIcon: Icon(icon, color: _textSecondary, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure!
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _textSecondary,
                  size: 20,
                ),
                onPressed: onToggle,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _goldPrimary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        isDense: true,
      ),
    );
  }
}

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

    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.8,
    );

    path.moveTo(size.width, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      0,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);

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
