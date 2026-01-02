import 'package:flutter/material.dart';
import '../../../../core/models/data.dart'; // Centralized data exports
import '../widgets/menu_product_card.dart'; // Relative to pages/.. -> widgets/
import '../../cart/pages/cart_page.dart';

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

  String _selectedCategory = 'All';

  // Filter Logic
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return menuProducts;
    }
    return menuProducts
        .where((p) => (p.category ?? 'Coffee') == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Unpinned Header (Title Scrolls Away) with Cart Icon
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
                        fontSize: 32, // Large Title
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

            // 2. Sticky Search & Tabs (Pins to Top)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickySearchDelegate(
                minHeight:
                    110, // Height for Search (50) + Gap (10) + Tabs (30) + Padding
                maxHeight: 110,
                child: Container(
                  color: _bgPage, // Opaque background to hide scrolling content
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
                            style: TextStyle(color: _textPrimary, fontSize: 14),
                            cursorColor: _goldAccent,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: _textSecondary.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: _textSecondary.withValues(alpha: 0.7),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tabs
                      SizedBox(height: 32, child: _buildMinimalTabs()),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Product Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.70, // Slightly taller to prevent overflow
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return MenuProductCard(product: _filteredProducts[index]);
                }, childCount: _filteredProducts.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalTabs() {
    final List<String> categories = ['All', 'Coffee', 'Non-Coffee', 'Food'];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 24),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory == category;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isSelected
                  ? Border(bottom: BorderSide(color: _textPrimary, width: 2))
                  : null,
            ),
            child: Text(
              category,
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
