import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rnh_pos/commont/filter_report_enum.dart';
import 'package:rnh_pos/domain/entities/sales_report.dart';
import 'package:rnh_pos/domain/entities/transaction.dart';
import 'package:rnh_pos/domain/usecases/transaction/get_transactions_use_case.dart';

import '../../commont/state_enum.dart';

class ReportNotifier extends ChangeNotifier {
  final GetTransactionsUseCase _getTransactionsUseCase;

  ReportNotifier({required GetTransactionsUseCase getTransactionsUseCase})
      : _getTransactionsUseCase = getTransactionsUseCase;

  List<SalesReport> _chartData = [];
  List<SalesReport> get chartData => _chartData;

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  FilterReport _filterReport = FilterReport.Today;
  FilterReport get filterReport => _filterReport;

  String _message = '';
  String get message => _message;

  final _mapFilterReport = {
    "Hari Ini": FilterReport.Today,
    "Minggu Ini": FilterReport.ThisWeek,
    "Bulan Ini": FilterReport.ThisMount,
  };

  Future<void> getTransactions(String filterKey) async {
    _state = RequestState.Loading;
    notifyListeners();

    _filterReport = _mapFilterReport[filterKey] ?? FilterReport.Today;

    final startAt = getStartAt(_filterReport);
    final endAt = getEndAt(_filterReport);

    final result = await _getTransactionsUseCase.execute(startAt, endAt);
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _state = RequestState.Loaded;
        _transactions = data;
        _setChartData(filterReport, startAt.day, endAt.day);
        notifyListeners();
      },
    );
  }

  DateTime getStartAt(FilterReport filterReport) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (filterReport == FilterReport.Today) {
      return now;
    } else if (filterReport == FilterReport.ThisWeek) {
      return now.subtract(Duration(days: now.weekday - 1));
    } else {
      return DateTime(now.year, now.month, 1);
    }
  }

  DateTime getEndAt(FilterReport filterReport) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (filterReport == FilterReport.Today) {
      return now.add(const Duration(days: 1));
    } else if (filterReport == FilterReport.ThisWeek) {
      return now.add(Duration(days: (DateTime.daysPerWeek - now.weekday) + 1));
    } else {
      return DateTime(now.year, now.month + 1, 0);
    }
  }

  void _setChartData(
    FilterReport filterReport,
    int startAt,
    int endAt,
  ) {
    _chartData = [];
    if (_transactions.isNotEmpty) {
      if (filterReport == FilterReport.Today) {
        final now = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
        for (var i = 0; i < 24; i++) {
          _chartData.add(
            SalesReport(
              now.add(Duration(hours: i)),
              0,
            ),
          );
        }
        for (var transaction in _transactions) {
          final index = _chartData.indexWhere((cart) => cart.date.hour == transaction.date.hour);
          _chartData[index] = SalesReport(
            transaction.date,
            _chartData[index].totalPrice + transaction.totalPrice,
          );
        }
      } else if (filterReport == FilterReport.ThisWeek) {
        for (var i = 0; i < 7; i++) {
          _chartData.add(SalesReport(DateTime.now(), 0));
        }
        for (var i = 6; i >= 0; i--) {
          final day = endAt - (6 - i) - 1 > 0 ? endAt - (6 - i) - 1 : startAt + i;
          final month = endAt - (6 - i) - 1 > 0 ? DateTime.now().month : DateTime.now().month - 1;
          final date = DateTime(
            DateTime.now().year,
            month,
            day,
          );

          _chartData[i] =
            SalesReport(
              date,
              0,
            );
        }
        for (var transaction in _transactions) {
          final index = _chartData.indexWhere((cart) => cart.date.day == transaction.date.day);
          _chartData[index] = SalesReport(
            transaction.date,
            _chartData[index].totalPrice + transaction.totalPrice,
          );
          print(transaction.date);
        }
        _chartData.forEach((element) {
          print(element.date);
        });
      } else {
        for (var i = 0; i < endAt; i++) {
          final date = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            i+1,
          );
          _chartData.add(
            SalesReport(
              date,
              0,
            ),
          );
        }
        for (var transaction in _transactions) {
          final index = _chartData.indexWhere((cart) => cart.date.day == transaction.date.day);
          _chartData[index] = SalesReport(
            transaction.date,
            _chartData[index].totalPrice + transaction.totalPrice,
          );
        }
      }
    }
  }
}
