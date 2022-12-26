import 'package:flutter/cupertino.dart';
import 'package:rnh_pos/presentation/pages/category_page.dart';
import 'package:rnh_pos/presentation/pages/report_page.dart';
import 'package:rnh_pos/presentation/pages/transaction_page.dart';
import 'package:rnh_pos/presentation/pages/product_page.dart';

class DrawerPageNotifier extends ChangeNotifier {
  late Widget _currentPage = const TransactionPage();
  Widget get currentPage => _currentPage;

  set currentPage(Widget newScreen) {
    _currentPage = newScreen;
    notifyListeners();
  }

  void changeCurrentPage(CustomPageEnum screen) {
    switch (screen) {
      case CustomPageEnum.HomePage:
        currentPage = const TransactionPage();
        break;
      case CustomPageEnum.ProductPage:
        currentPage = const ProductPage();
        break;
      case CustomPageEnum.CategoryPage:
        currentPage = const CategoryPage();
        break;
      case CustomPageEnum.ReportPage:
        currentPage = const ReportPage();
        break;
      default:
        currentPage = const TransactionPage();
        break;
    }
  }
}

enum CustomPageEnum { HomePage, ProductPage, CategoryPage, ReportPage }
