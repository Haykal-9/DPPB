import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/config/api_config.dart';
import '../../../core/services/user_session.dart';
import '../../cart/pages/cart_page.dart';
import '../../order/pages/order_history_page.dart';
import '../../reservation/pages/reservation_page.dart';
import '../data/models/api_product.dart';
import '../data/models/api_category.dart';
import '../data/services/home_service.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/shimmer_loading.dart';
import 'main_wrapper.dart';

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

  // Services
  final HomeService _homeService = HomeService();

  // Carousel State
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // API Data
  List<ApiProduct> _allProducts = []; // Store all products
  List<ApiProduct> _featuredProducts = [];
  List<ApiProduct> _latestProducts = [];
  List<ApiCategory> _categories = [];
  bool _isLoadingProducts = true;
  bool _isLoadingCategories = true;
  String? _selectedCategory; // Use category name for filtering

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
      'image': 'assets/images/kopi/ES KOPI SUSU.jpg',
      'tag': 'SIGNATURE',
      'title': 'Taste Our\nSignature Blends',
      'subtitle':
          'Crafted with passion and precision for the ultimate coffee experience.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
    _loadData();
  }

  void _startCarouselTimer() {
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

  Future<void> _loadData() async {
    await Future.wait([_loadProducts(), _loadCategories()]);
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoadingProducts = true);

    try {
      final products = await _homeService.getProducts(limit: 20);

      if (mounted) {
        setState(() {
          _allProducts = products;
          _applyFilter();
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
      if (mounted) {
        setState(() => _isLoadingProducts = false);
      }
    }
  }

  /// Apply category filter to products
  void _applyFilter() {
    if (_selectedCategory == null) {
      // No filter - show all
      _featuredProducts = _allProducts.take(6).toList();
      _latestProducts = _allProducts.reversed.take(6).toList();
    } else {
      // Filter by category
      final filtered = _allProducts
          .where(
            (p) =>
                p.kategoriNama?.toLowerCase() ==
                _selectedCategory?.toLowerCase(),
          )
          .toList();
      _featuredProducts = filtered.take(6).toList();
      _latestProducts = filtered.reversed.take(6).toList();
    }
  }

  /// Handle category selection
  void _onCategorySelected(String? categoryName) {
    setState(() {
      _selectedCategory = _selectedCategory == categoryName
          ? null
          : categoryName;
      _applyFilter();
    });
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCategories = true);

    try {
      final categories = await _homeService.getCategories();

      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _getUserName() {
    final user = UserSession.instance.currentUser;
    if (user != null) {
      return user.nama.split(' ').first; // First name only
    }
    return 'Coffee Lover';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: _goldPrimary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(child: _buildAppBar()),

              // Hero Carousel
              SliverToBoxAdapter(child: _buildHeroCarousel()),

              // Quick Access Section (moved above categories)
              SliverToBoxAdapter(child: _buildQuickAccessSection()),

              // Categories Section
              SliverToBoxAdapter(child: _buildCategoriesSection()),

              // Featured Products Section
              SliverToBoxAdapter(child: _buildFeaturedSection()),

              // Latest Products Section
              SliverToBoxAdapter(child: _buildLatestSection()),

              // Bottom Quote
              SliverToBoxAdapter(child: _buildBottomQuote()),

              // Bottom Padding
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getUserName(),
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

          // Actions
          Row(
            children: [
              // Cart Button
              _buildIconButton(
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              const SizedBox(width: 8),
              // Profile Avatar
              _buildProfileAvatar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _textPrimary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: _textPrimary, size: 22),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    final user = UserSession.instance.currentUser;
    String? imageUrl;

    if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
      imageUrl = user.profilePicture!.startsWith('http')
          ? user.profilePicture
          : '${ApiConfig.imageBaseUrl}${user.profilePicture}';
    }

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _textPrimary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _goldPrimary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: _goldPrimary.withValues(alpha: 0.1),
      child: Icon(Icons.person, color: _goldPrimary, size: 24),
    );
  }

  Widget _buildHeroCarousel() {
    return SizedBox(
      height: 220,
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
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _heroItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 20 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? _goldPrimary
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(item['image']!),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: _textPrimary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _goldPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item['tag']!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  item['subtitle']!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: _isLoadingCategories
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 4,
                  itemBuilder: (_, __) => const CategoryChipShimmer(),
                )
              : _categories.isEmpty
              ? _buildDefaultCategories()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChip(
                      category: category,
                      isSelected: _selectedCategory == category.nama,
                      onTap: () => _onCategorySelected(category.nama),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDefaultCategories() {
    final defaultCategories = [
      {'name': 'Coffee', 'icon': Icons.coffee},
      {'name': 'Non-Coffee', 'icon': Icons.local_drink},
      {'name': 'Food', 'icon': Icons.restaurant},
      {'name': 'Snacks', 'icon': Icons.fastfood},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: defaultCategories.length,
      itemBuilder: (context, index) {
        final cat = defaultCategories[index];
        return SimpleCategoryChip(
          name: cat['name'] as String,
          icon: cat['icon'] as IconData,
          isSelected: index == 0,
        );
      },
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu Favorit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to menu page (index 1 in MainWrapper)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainWrapper(initialIndex: 1),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _goldPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: _isLoadingProducts
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 3,
                  itemBuilder: (_, __) => const ProductCardShimmer(),
                )
              : _featuredProducts.isEmpty
              ? _buildEmptyProductsMessage()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _featuredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: _featuredProducts[index],
                      onTap: () {
                        // Navigate to product detail
                      },
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${_featuredProducts[index].nama} ditambahkan ke keranjang',
                            ),
                            backgroundColor: _goldPrimary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyProductsMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee_outlined,
              size: 48,
              color: _textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada produk',
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Pastikan API endpoint tersedia',
              style: TextStyle(
                color: _textSecondary.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Fitur Favorites akan segera hadir!'),
                  backgroundColor: _goldPrimary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          _buildQuickAccessItem(
            icon: Icons.confirmation_number_outlined,
            label: 'Vouchers',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Fitur Vouchers akan segera hadir!'),
                  backgroundColor: _goldPrimary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
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
            icon: Icons.restaurant_menu_rounded,
            label: 'Reservation',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReservationPage(),
                ),
              );
            },
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
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _bgPage, shape: BoxShape.circle),
            child: Icon(icon, color: _textPrimary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestSection() {
    if (_latestProducts.isEmpty && !_isLoadingProducts) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to menu page (index 1 in MainWrapper)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainWrapper(initialIndex: 1),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _goldPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: _isLoadingProducts
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 3,
                  itemBuilder: (_, __) => const ProductCardShimmer(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _latestProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: _latestProducts[index],
                      onTap: () {
                        // Navigate to product detail
                      },
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${_latestProducts[index].nama} ditambahkan ke keranjang',
                            ),
                            backgroundColor: _goldPrimary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBottomQuote() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Text(
          '"Life begins after coffee"',
          style: TextStyle(
            color: _textSecondary.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
            fontFamily: 'Serif',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
