import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_icon_button.dart';

class EditDelete extends StatelessWidget {
  final VoidCallback editOnTap;
  final VoidCallback deleteOnTap;
  const EditDelete({Key? key, required this.editOnTap, required this.deleteOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          height: 26.0,
          width: 26.0,
          asset: "assets/ic_edit.svg",
          onTap: editOnTap,
        ),
        const SizedBox(
          width: 12.0,
        ),
        CustomIconButton(
          height: 26.0,
          width: 26.0,
          asset: "assets/ic_delete.svg",
          onTap: deleteOnTap,
        ),
      ],
    );
  }
}
