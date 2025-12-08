import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.brown : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.brown : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
