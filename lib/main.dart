import 'package:flutter/material.dart';
import 'features/home/pages/main_wrapper.dart';
import 'features/auth/pages/login_page.dart';
import 'core/services/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi UserSession sebelum app berjalan
  await UserSession.instance.init();

  runApp(const MyApp());
}

/// MyApp sebagai Root Widget (MaterialApp)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapal Kuda Coffee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      // Cek apakah user sudah login, jika sudah langsung ke home
      initialRoute: UserSession.instance.isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MainWrapper(),
      },
    );
  }
}
