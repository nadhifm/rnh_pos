import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/transaction_detail_widget.dart';

class TransactionDetailPage extends StatelessWidget {
  static const ROUTE_NAME = '/detail-transaction';

  final Transaction transaction;

  const TransactionDetailPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    formatter.maximumFractionDigits = 0;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFFEDE6DB),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 30.0,
                              width: 30.0,
                              asset: "assets/ic_back.svg",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Text(
                              "Detail Transaksi",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: const Color(0xFF1A3C40),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 30.0,
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transaksi",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF1A3C40),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          transaction.id.substring(0, 9),
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pembayaran",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1A3C40),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Tunai",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Transaksi",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1A3C40),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatter.format(transaction.totalPrice).toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tunai Diterima",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1A3C40),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatter.format(transaction.pay).toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kembalian",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1A3C40),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatter.format(transaction.change).toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF417D7A),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Detail Produk",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF1A3C40),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return TransactionDetailWidget(cart: transaction.carts[index]);
            },
            childCount: transaction.carts.length,
          ),
        ),
          ],
        ),
      ),
    );
  }
}
