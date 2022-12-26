import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItem extends StatelessWidget {
  final String asset;
  final String text;
  final VoidCallback onTap;

  const DrawerItem(
      {Key? key, required this.asset, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(
              asset,
              color: const Color(0xFF417D7A),
            ),
            SizedBox(
              width: 24.0,
            ),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF1A3C40),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
