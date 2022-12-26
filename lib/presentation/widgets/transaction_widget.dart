import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/widgets/edit_delete.dart';
import 'package:rnh_pos/presentation/widgets/primary_button.dart';

import '../../domain/entities/cart.dart';
import 'custom_icon_button.dart';

class TransactionWidget extends StatefulWidget {
  final Cart cart;

  const TransactionWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {

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
                    height: 80,
                    width: 80,
                    image: NetworkImage(widget.cart.imageUrl),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    EditDelete(
                      editOnTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Consumer<TransactionNotifier>(
                                builder: (context, data, child) {
                              final cart = data.carts.firstWhere(
                                  (cart) => cart.id == widget.cart.id);
                              return Material(
                                color: Colors.transparent,
                                child: Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    width: 230,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Jumlah Produk",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: const Color(0xFF1A3C40),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomIconButton(
                                              height: 36.0,
                                              width: 36.0,
                                              asset: "assets/ic_minus.svg",
                                              onTap: () {
                                                if (cart.quantity > 1) {
                                                  data.minusQuantity(cart.id);
                                                }
                                              },
                                            ),
                                            Text(
                                              cart.quantity.toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF1A3C40),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            CustomIconButton(
                                              height: 36.0,
                                              width: 36.0,
                                              asset: "assets/ic_plus.svg",
                                              onTap: () {
                                                data.plusQuantity(cart.id);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        PrimaryButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          text: "Tutup",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                      deleteOnTap: () {
                        Provider.of<TransactionNotifier>(context, listen: false)
                            .removeCart(widget.cart.id);

                        final cartLength = Provider.of<TransactionNotifier>(
                                context,
                                listen: false)
                            .carts
                            .length;
                        if (cartLength == 0) {
                          Navigator.pop(context);
                        }
                      },
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
