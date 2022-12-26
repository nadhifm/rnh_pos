import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_icon_button.dart';

class MinusPlusQuantity extends StatelessWidget {
  final VoidCallback plusOnTap;
  final VoidCallback minusOnTap;
  final int quantity;

  const MinusPlusQuantity({
    Key? key,
    required this.plusOnTap,
    required this.minusOnTap,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return quantity == 0
        ? CustomIconButton(
            height: 26.0,
            width: 26.0,
            asset: "assets/ic_plus.svg",
            onTap: plusOnTap,
          )
        : Row(
            children: [
              CustomIconButton(
                height: 26.0,
                width: 26.0,
                asset: "assets/ic_minus.svg",
                onTap: minusOnTap,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                quantity.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1A3C40),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 12.0,
              ),
              CustomIconButton(
                height: 26.0,
                width: 26.0,
                asset: "assets/ic_plus.svg",
                onTap: plusOnTap,
              ),
            ],
          );
  }
}
