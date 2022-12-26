import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/success_transaction_page.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/widgets/primary_button.dart';

import '../../commont/state_enum.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';

class PayPage extends StatefulWidget {
  static const ROUTE_NAME = '/pay';

  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    formatter.maximumFractionDigits = 0;
    final totalPrice = Provider.of<TransactionNotifier>(context, listen: false)
        .totalPrice;
    final lengthListPaymenst = Provider.of<TransactionNotifier>(context, listen: false)
        .listPayments.length;

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
                              "Pembayaran",
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
            const SliverPadding(padding: EdgeInsets.only(top: 8.0)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                    ),
                    Text(
                      "Total Bayar",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF1A3C40),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      formatter.format(totalPrice).toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: const Color(0xFF1A3C40),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    CustomTextField(
                      controller: controller,
                      hint: "Tunai diterima",
                      inputType: TextInputType.number,
                      onChanged: (_) {
                        Provider.of<TransactionNotifier>(context, listen: false).setSelectedPay(0);
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    lengthListPaymenst > 0
                        ? SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Jumlah Lain",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF1A3C40),
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
            Consumer<TransactionNotifier>(
            builder: (context, data, child) {
              final selectedPay = data.selectedPay;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final pay = data.listPayments[index];
                      return InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedPay == pay ? const Color(0xFF1A3C40) : const Color(0x40417D7A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pay == totalPrice
                                ? "Uang Pas"
                                : formatter
                                .format(pay)
                                .toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: selectedPay == pay ? const Color(0xFFEDE6DB) : const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        onTap: () {
                          data.setSelectedPay(pay);
                        },
                      );
                    },
                    childCount: data.listPayments.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.0,
                  ),
                ),
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 16.0, left: 16.0),
        child: PrimaryButton(
          onPressed: () async {
            final selectedPay = Provider.of<TransactionNotifier>(context, listen: false).selectedPay;
            if (selectedPay == 0 && controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Masukan Tunai Yang Diterima")));
              return;
            } else {
              final pay = selectedPay == 0 ? int.parse(controller.text) : selectedPay;

              showDialog(
                context: context,
                builder: (context) {
                  return Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          color: Colors.white,
                        ),
                        height: 120,
                        width: 120,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFF1A3C40),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              "Loading",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF1A3C40),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              await Provider.of<TransactionNotifier>(context, listen: false)
                  .addTransaction(pay);

              if (!mounted) return;

              final state =
                  Provider.of<TransactionNotifier>(context, listen: false).state;
              if (state == RequestState.Loaded) {
                Navigator.pop(context);
                final transaction =
                    Provider.of<TransactionNotifier>(context, listen: false).transaction;
                Navigator.pushNamed(
                  context,
                  SuccessTransactionPage.ROUTE_NAME,
                  arguments: transaction,
                );
              } else if (state == RequestState.Error) {
                Navigator.pop(context);
                final message =
                    Provider.of<TransactionNotifier>(context, listen: false).message;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            }
          },
          text: 'Bayar',
        ),
      ),
    );
  }

}
