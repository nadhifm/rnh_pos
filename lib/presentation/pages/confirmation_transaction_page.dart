import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/pay_page.dart';

import '../../commont/state_enum.dart';
import '../provider/transaction_notifier.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/primary_button.dart';
import '../widgets/transaction_widget.dart';

class ConfirmationTransactionPage extends StatefulWidget {
  static const ROUTE_NAME = '/confirmation-transaction';

  const ConfirmationTransactionPage({Key? key}) : super(key: key);

  @override
  State<ConfirmationTransactionPage> createState() =>
      _ConfirmationTransactionPageState();
}

class _ConfirmationTransactionPageState
    extends State<ConfirmationTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                  height: 30.0,
                                  width: 30.0,
                                  asset: "assets/ic_back.svg",
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Text(
                                  "Konfirmasi Transaksi",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: const Color(0xFF1A3C40),
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
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
                Consumer<TransactionNotifier>(
                  builder: (context, data, child) {
                    final state = data.getProductsState;
                    if (state == RequestState.Loading) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1A3C40),
                          ),
                        ),
                      );
                    } else if (state == RequestState.Loaded) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return TransactionWidget(cart: data.carts[index]);
                          },
                          childCount: data.carts.length,
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                        ),
                      );
                    }
                  },
                ),
                const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 50)),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PrimaryButton(
                    text: "Konfirmasi",
                    onPressed: () {
                      Provider.of<TransactionNotifier>(context, listen: false).confirmationTransaction();
                      Navigator.pushNamed(context, PayPage.ROUTE_NAME);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
