import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rnh_pos/domain/entities/category.dart';

class CustomTab extends StatelessWidget {
  final Function() onTap;
  final String selectedTab;
  final Category category;

  const CustomTab({Key? key, required this.selectedTab, required this.category, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(left: category.id == "" ? 16.0 : 8.0),
        decoration: BoxDecoration(
          color: selectedTab == category.id ? const Color(0xFF1A3C40) : const Color(0x40417D7A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            category.name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: selectedTab == category.id ? const Color(0xFFEDE6DB) : const Color(0xFF1A3C40),
            ),
          ),
        ),
      ),
    );
  }
}
