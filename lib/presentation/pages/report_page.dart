import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/commont/filter_report_enum.dart';
import 'package:rnh_pos/commont/filter_report_enum.dart';
import 'package:rnh_pos/commont/filter_report_enum.dart';
import 'package:rnh_pos/domain/entities/sales_report.dart';
import 'package:rnh_pos/domain/entities/sales_report.dart';
import 'package:rnh_pos/domain/entities/sales_report.dart';
import 'package:rnh_pos/presentation/pages/transaction_detail_page.dart';
import 'package:rnh_pos/presentation/provider/report_notifier.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../commont/state_enum.dart';
import '../widgets/custom_icon_button.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReportNotifier>(context, listen: false)
          .getTransactions("Hari Ini");
    });
  }

  final listFilter = ["Hari Ini", "Minggu Ini", "Bulan Ini"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                            asset: "assets/ic_drawer.svg",
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                          Text(
                            "Laporan",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Penjualan",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF1A3C40),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField(
                      value: listFilter[0],
                      items: listFilter
                          .map((filter) => DropdownMenuItem(
                                value: filter,
                                child: Text(
                                  filter,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF1A3C40),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          Provider.of<ReportNotifier>(context, listen: false)
                              .getTransactions(val);
                        }
                      },
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF1A3C40),
                      ),
                      icon: SvgPicture.asset("assets/ic_drop_down.svg"),
                      dropdownColor: const Color(0xFFEDE6DB),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 6.0, bottom: 4.0, left: 12.0, right: 6.0),
                        isDense: true,
                        filled: true,
                        fillColor: Color(0x40417D7A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 16.0)),
          Consumer<ReportNotifier>(builder: (context, data, child) {
            final state = data.state;
            if (state == RequestState.Loaded) {
              final chartData = data.chartData;
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 4.0, bottom: 4.0, right: 10.0, top: 16.0),
                        height: 300,
                        decoration: BoxDecoration(
                            color: const Color(0x40417D7A),
                            borderRadius: BorderRadius.circular(16.0)),
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            interval: data.filterReport == FilterReport.ThisWeek
                                ? 1
                                : data.filterReport == FilterReport.ThisMount
                                    ? 3
                                    : 2,
                            dateFormat: data.filterReport == FilterReport.Today
                                ? DateFormat("HH")
                                : DateFormat("dd/MM"),
                            title: AxisTitle(
                                text: data.filterReport == FilterReport.Today
                                    ? 'Jam'
                                    : 'Hari'),
                            labelRotation: -45,
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Total Penjualan'),
                          ),
                          series: <ChartSeries>[
                            // Renders line chart
                            SplineAreaSeries<SalesReport, DateTime>(
                              name: "Penjualan",
                              color: const Color(0xFF1A3C40),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF417D7A),
                                  Color(0x4D417D7A),
                                ],
                              ),
                              borderColor: const Color(0xFF1A3C40),
                              borderWidth: 2,
                              dataSource: chartData,
                              splineType: SplineType.cardinal,
                              xValueMapper: (SalesReport data, _) => data.date,
                              yValueMapper: (SalesReport data, _) =>
                                  data.totalPrice,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        "Riwayat Transaksi",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF1A3C40),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SliverPadding(padding: EdgeInsets.only(top: 16.0));
            }
          }),
          const SliverPadding(padding: EdgeInsets.only(top: 16.0)),
          Consumer<ReportNotifier>(
            builder: (context, data, child) {
              final state = data.state;

              if (state == RequestState.Loading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A3C40),
                    ),
                  ),
                );
              } else if (state == RequestState.Loaded) {
                final transactions = data.transactions;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final transaction = transactions[index];
                      final numberFormatter =
                          NumberFormat.simpleCurrency(locale: 'id_ID');
                      numberFormatter.maximumFractionDigits = 0;
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            TransactionDetailPage.ROUTE_NAME,
                            arguments: transaction,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              SvgPicture.asset("assets/ic_receipt.svg"),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.id.substring(0, 9),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF1A3C40),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(transaction.date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xCC1A3C40),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    numberFormatter
                                        .format(transaction.totalPrice),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF1A3C40),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${transaction.carts.length} Produk",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xCC1A3C40),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              SvgPicture.asset(
                                "assets/ic_next.svg",
                                width: 28,
                                height: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: transactions.length,
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
        ],
      ),
    );
  }
}
