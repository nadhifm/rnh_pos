import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  final double height;
  final double width;
  final String asset;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.height,
    required this.width,
    required this.asset,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Color(0x40417D7A),
          borderRadius: BorderRadius.all(Radius.circular(
            4.0,
          )),
        ),
        child: SvgPicture.asset(asset),
      ),
    );
  }
}
