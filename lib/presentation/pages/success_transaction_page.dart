import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/domain/entities/transaction.dart';
import 'package:rnh_pos/presentation/pages/home_page.dart';

import '../provider/transaction_notifier.dart';
import '../widgets/primary_button.dart';

class SuccessTransactionPage extends StatelessWidget {
  static const ROUTE_NAME = '/success-transaction';
  final Transaction transaction;

  const SuccessTransactionPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    formatter.maximumFractionDigits = 0;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/ic_success.svg",
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Transasi Berhasil",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: const Color(0xFF1A3C40),
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        transaction.date.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: const Color(0xFF1A3C40),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pembayaran",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Tunai",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF417D7A),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Transaksi",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            formatter.format(transaction.totalPrice).toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF417D7A),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tunai Diterima",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            formatter.format(transaction.pay).toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF417D7A),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kembalian",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            formatter.format(transaction.change).toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF417D7A),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  PrimaryButton(
                    onPressed: () {
                      Provider.of<TransactionNotifier>(context, listen: false)
                          .resetCart();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.ROUTE_NAME, (Route<dynamic> route) => false);
                    },
                    text: 'Kembali',
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
