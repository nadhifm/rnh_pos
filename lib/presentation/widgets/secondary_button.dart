import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const SecondaryButton(
      {Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1.5, color: Color(0xFF1A3C40)),
            foregroundColor: const Color(0xFF1A3C40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16)),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A3C40),
          ),
        ),
      ),
    );
  }
}
