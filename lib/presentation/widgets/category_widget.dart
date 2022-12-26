import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rnh_pos/domain/entities/category.dart';
import 'package:rnh_pos/presentation/widgets/edit_delete.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final VoidCallback editOnTap;
  final VoidCallback deleteOnTap;
  const CategoryWidget({Key? key, required this.category, required this.editOnTap, required this.deleteOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color(0xFF417D7A),
          width: 0.3,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            category.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF1A3C40),
              fontWeight: FontWeight.w500,
            ),
          ),
          EditDelete(
            editOnTap: editOnTap,
            deleteOnTap: deleteOnTap,
          ),
        ],
      ),
    );
  }
}
