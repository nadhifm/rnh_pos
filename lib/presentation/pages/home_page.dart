import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/transaction_page.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/widgets/drawer_item.dart';

import '../provider/drawer_page_notifier.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nadhif Mahardika",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFF1A3C40),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Owner",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF417D7A),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x40417D7A),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DrawerItem(
                    asset: "assets/ic_cashier.svg",
                    text: "Transaksi",
                    onTap: () {
                      Provider.of<DrawerPageNotifier>(context, listen: false)
                          .changeCurrentPage(CustomPageEnum.HomePage);
                      Provider.of<TransactionNotifier>(context, listen: false)
                          .resetCart();
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  DrawerItem(
                    asset: "assets/ic_product.svg",
                    text: "Produk",
                    onTap: () {
                      Provider.of<DrawerPageNotifier>(context, listen: false)
                          .changeCurrentPage(CustomPageEnum.ProductPage);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  DrawerItem(
                    asset: "assets/ic_category.svg",
                    text: "Kategori",
                    onTap: () {
                      Provider.of<DrawerPageNotifier>(context, listen: false)
                          .changeCurrentPage(CustomPageEnum.CategoryPage);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  DrawerItem(
                    asset: "assets/ic_report.svg",
                    text: "Laporan Penjulan",
                    onTap: () {
                      Provider.of<DrawerPageNotifier>(context, listen: false)
                          .changeCurrentPage(CustomPageEnum.ReportPage);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<DrawerPageNotifier>(builder: (context, value, child) {
          return value.currentPage;
        }),
      ),
    );
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime != null &&
        now.difference(currentBackPressTime!) < const Duration(seconds: 2)) {
      return Future.value(true);
    } else {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Tekan Sekali Lagi Untuk Keluar",
        ),
        duration: Duration(seconds: 2),
      ));
      return Future.value(false);
    }
  }
}
