import 'package:flutter/material.dart';

import '../../../../core/models/data.dart'; // Centralized data exports
import '../widgets/menu_product_card.dart'; // Relative to pages/.. -> widgets/
import '../../cart/pages/cart_page.dart';

import '../../home/data/models/api_product.dart';
import '../../home/data/services/home_service.dart';
import '../widgets/api_menu_product_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Theme Constants
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);
  final Color _goldAccent = const Color(0xFFD4AF37);

  // Services
  final HomeService _homeService = HomeService();

  // State
  List<ApiProduct> _allProducts = [];
  List<ApiProduct> _filteredProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMenus() async {
    setState(() => _isLoading = true);

    try {
      final products = await _homeService.getMenus();

      // Extract unique categories
      final Set<String> categorySet = {'All'};
      for (final product in products) {
        if (product.kategoriNama != null && product.kategoriNama!.isNotEmpty) {
          categorySet.add(product.kategoriNama!);
        }
      }

      if (mounted) {
        setState(() {
          _allProducts = products;
          _categories = categorySet.toList();
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading menus: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyFilters() {
    List<ApiProduct> filtered = _allProducts;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
            (p) =>
                p.kategoriNama?.toLowerCase() ==
                _selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.nama.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadMenus,
          color: _goldAccent,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Title Header with Cart Icon
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                          fontSize: 32,
                        ),
                      ),
                      // Cart Icon
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: _textPrimary,
                          size: 28,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Sticky Search & Tabs
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickySearchDelegate(
                  minHeight: 110,
                  maxHeight: 110,
                  child: Container(
                    color: _bgPage,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                              ),
                              cursorColor: _goldAccent,
                              decoration: InputDecoration(
                                hintText: 'Cari menu...',
                                hintStyle: TextStyle(
                                  color: _textSecondary.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: _textSecondary.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: _textSecondary,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _onSearchChanged('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Category Tabs
                        SizedBox(height: 32, child: _buildCategoryTabs()),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Product Grid or Loading/Empty State
              if (_isLoading)
                SliverToBoxAdapter(child: _buildLoadingState())
              else if (_filteredProducts.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.70,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ApiMenuProductCard(
                        product: _filteredProducts[index],
                      );
                    }, childCount: _filteredProducts.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _categories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 24),
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategory == category;

        return GestureDetector(
          onTap: () => _onCategorySelected(category),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isSelected
                  ? Border(bottom: BorderSide(color: _textPrimary, width: 2))
                  : null,
            ),
            child: Text(
              _formatCategoryName(category),
              style: TextStyle(
                color: isSelected
                    ? _textPrimary
                    : _textSecondary.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
                fontFamily: isSelected ? 'Serif' : null,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatCategoryName(String category) {
    // Capitalize first letter of each word
    if (category == 'All') return 'Semua';
    return category
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            CircularProgressIndicator(color: _goldAccent),
            const SizedBox(height: 16),
            Text(
              'Memuat menu...',
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: _textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Menu "$_searchQuery" tidak ditemukan'
                  : 'Tidak ada menu tersedia',
              style: TextStyle(color: _textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate for Sticky Search + Tabs
class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickySearchDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickySearchDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
