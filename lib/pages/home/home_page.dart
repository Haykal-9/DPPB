import 'dart:async';
import 'package:flutter/material.dart';
import '../cart/cart_page.dart';
// Favorites and Vouchers pages removed as per request
import '../profile/order_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Theme Constants (Light Luxury)
  final Color _bgPage = const Color(0xFFF9F5F0); // Cream / Off-White
  final Color _goldPrimary = const Color(0xFFD4AF37); // Gold
  final Color _textPrimary = const Color(0xFF2C2219); // Deep Coffee
  final Color _textSecondary = const Color(0xFF8D7B68); // Soft Brown

  // Carousel State
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Hero Data
  final List<Map<String, String>> _heroItems = [
    {
      'image': 'assets/images/kopi/CAPPUCINO.jpg',
      'tag': 'PREMIUM SERIES',
      'title': 'Experience the\nPerfect Brew',
      'subtitle':
          'Discover the artistry in every cup. Locally sourced, expertly roasted.',
    },
    {
      'image': 'assets/images/makanan/biji.jpg',
      'tag': 'FRESH ROAST',
      'title': 'Roasted Daily\nFor Freshness',
      'subtitle':
          'Our beans are roasted in small batches to ensure peak flavor profile.',
    },
    {
      'image': 'assets/images/kopi/ES_KOPI_SUSU.jpg', // Placeholder if needed
      'tag': 'SIGNATURE',
      'title': 'Taste Our\nSignature Blends',
      'subtitle':
          'Crafted with passion and precision for the ultimate coffee experience.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll logic
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _heroItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      appBar: _buildReviewAppBar(),
      body: _buildCinematicBody(),
    );
  }

  PreferredSizeWidget _buildReviewAppBar() {
    return AppBar(
      backgroundColor: _bgPage,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
          Text(
            'Coffee Lover',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 24,
              fontFamily: 'Serif',
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        // Cart Navigation Icon
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: _textPrimary,
              size: 28,
            ),
          ),
        ),

        // Logo
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, color: _goldPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCinematicBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),

        // 1. Dynamic Hero Carousel
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _heroItems.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildHeroItem(_heroItems[index]);
                },
              ),

              // Page Indicators
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _heroItems.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _goldPrimary
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 2. Quick Access Card (Unified)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _textPrimary.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessItem(
                icon: Icons.favorite_border_rounded,
                label: 'Favorites',
                onTap: () {
                  // Disabled as per request
                },
              ),
              _buildQuickAccessItem(
                icon: Icons.confirmation_number_outlined,
                label: 'Vouchers',
                onTap: () {
                  // Disabled as per request
                },
              ),
              _buildQuickAccessItem(
                icon: Icons.history_rounded,
                label: 'Orders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryPage(),
                    ),
                  );
                },
              ),
              _buildQuickAccessItem(
                icon: Icons.headset_mic_outlined, // Support / Help placeholder
                label: 'Support',
                onTap: () {
                  // Placeholder
                },
              ),
            ],
          ),
        ),

        // Spacer to balance layout
        const Spacer(flex: 1),

        // Bottom Quote
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Center(
            child: Text(
              '"Life begins after coffee"',
              style: TextStyle(
                color: _textSecondary.withOpacity(0.7),
                fontStyle: FontStyle.italic,
                fontFamily: 'Serif',
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: AssetImage(item['image']!),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: _textPrimary.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _goldPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['tag']!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  item['subtitle']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16), // Extra space for indicators
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5F0), // Light Cream background
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _textPrimary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
