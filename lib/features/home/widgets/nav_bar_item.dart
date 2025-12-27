import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected
              ? const Color(0xFFD4AF37)
              : const Color(0xFF8D7B68), // Gold : Soft Brown
          size: 24, // Explicit size
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF2C2219)
                : const Color(0xFF8D7B68), // Deep Coffee : Soft Brown
            fontSize: 10, // Smaller font
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
