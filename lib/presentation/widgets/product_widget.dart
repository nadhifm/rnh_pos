import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rnh_pos/domain/entities/product.dart';

class ProductWidget extends StatefulWidget {
  final Widget action;
  final Product product;

  const ProductWidget({
    Key? key,
    required this.action,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    formatter.maximumFractionDigits = 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: const Color(0xFF417D7A),
          width: 0.3,
        )),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.product.imageUrl != ""
                ? Image(
                    height: 80,
                    width: 80,
                    image: NetworkImage(widget.product.imageUrl),
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 80,
                    width: 80,
                    color: const Color(0x40417D7A),
                    child: Center(
                      child: Text(
                        "PR",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: const Color(0xFF1A3C40),
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1A3C40),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stok: ${widget.product.stock}",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xCC1A3C40),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          formatter
                              .format(widget.product.sellingPrice)
                              .toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    widget.action,
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
