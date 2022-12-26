import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/widgets/edit_delete.dart';
import 'package:rnh_pos/presentation/widgets/primary_button.dart';

import '../../domain/entities/cart.dart';
import 'custom_icon_button.dart';

class TransactionDetailWidget extends StatefulWidget {
  final Cart cart;

  const TransactionDetailWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<TransactionDetailWidget> createState() => _TransactionDetailWidgetState();
}

class _TransactionDetailWidgetState extends State<TransactionDetailWidget> {

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
          color: Color(0xFF417D7A),
          width: 0.3,
        )),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.cart.imageUrl != ""
                ? Image(
                    height: 50,
                    width: 50,
                    image: NetworkImage(widget.cart.imageUrl),
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 50,
                    width: 50,
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
                  widget.cart.name,
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
                        Text(
                          "${widget.cart.quantity} x ${formatter.format(widget.cart.price)}",
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
                              .format(widget.cart.quantity * widget.cart.price)
                              .toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w500),
                        ),
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
