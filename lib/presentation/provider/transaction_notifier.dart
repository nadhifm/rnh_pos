import 'package:flutter/material.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/entities/transaction.dart';

import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/category/get_categories_use_case.dart';
import '../../domain/usecases/product/get_products_use_case.dart';
import '../../domain/usecases/transaction/add_transaction_use_case.dart';

class TransactionNotifier extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final AddTransactionUseCase _addTransactionUseCase;

  TransactionNotifier({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetProductsUseCase getProductsUseCase,
    required final AddTransactionUseCase addTransactionUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _getProductsUseCase = getProductsUseCase,
        _addTransactionUseCase = addTransactionUseCase;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  String _selectedTab = "";
  String get selectedTab => _selectedTab;

  RequestState _getCategoriesState = RequestState.Empty;
  RequestState get getCategoriesState => _getCategoriesState;

  List<Product> _products = [];

  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts;

  RequestState _getProductsState = RequestState.Empty;
  RequestState get getProductsState => _getProductsState;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Cart> _carts = [];
  List<Cart> get carts => _carts;

  Transaction? _transaction;
  Transaction? get transaction => _transaction;

  String _message = '';
  String get message => _message;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  int _selectedPay = 0;
  int get selectedPay => _selectedPay;

  List<int> _listPayments = [];
  List<int> get listPayments => _listPayments;


  Future<void> getCategories() async {
    _getCategoriesState = RequestState.Loading;
    notifyListeners();

    final result = await _getCategoriesUseCase.execute();
    result.fold(
      (failure) {
        _getCategoriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _getCategoriesState = RequestState.Loaded;
        _categories = data;
        notifyListeners();
      },
    );
  }

  Future<void> getProducts() async {
    _getProductsState = RequestState.Loading;
    notifyListeners();

    final result = await _getProductsUseCase.execute();
    result.fold(
      (failure) {
        _getProductsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _getProductsState = RequestState.Loaded;
        _products = data;
        _filteredProducts = _products;
        notifyListeners();
      },
    );
  }

  int checkCart(String productId) {
    return _carts.indexWhere((element) => element.id == productId);
  }

  void plusQuantity(String productId) {
    final index = _carts.indexWhere((element) => element.id == productId);
    final product = _products.where((element) => element.id == productId).first;
    if (index == -1) {
      _carts.add(
        Cart(
          id: product.id,
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.sellingPrice,
          stock: product.stock,
          quantity: 1,
        ),
      );
    } else {
      final quantity = _carts[index].quantity;
      if (quantity < product.stock) {
        _carts[index].quantity = _carts[index].quantity + 1;
      }
    }
    notifyListeners();
  }

  void minusQuantity(String productId) {
    final index = _carts.indexWhere((element) => element.id == productId);
    if (index != -1) {
      final quantity = _carts[index].quantity;
      if (quantity == 1) {
        _carts.removeAt(index);
      } else {
        _carts[index].quantity = quantity - 1;
      }
    }
    notifyListeners();
  }

  void removeCart(String cartId) {
    int index = _carts.indexWhere((element) => element.id == cartId);
    _carts.removeAt(index);
    notifyListeners();
  }

  void confirmationTransaction() {
    int total = 0;
    for (var cart in _carts) {
      total = total + (cart.price * cart.quantity);
    }

    _totalPrice = total;

    _listPayments = [
    5000,
    10000,
    15000,
    20000,
    25000,
    30000,
    50000,
    100000,
    totalPrice
    ].where((e) => e >= totalPrice).toList();
  }

  Future<void> addTransaction(int pay) async {
    _state = RequestState.Loading;
    notifyListeners();

    final totalPrice = _totalPrice;
    if (pay < totalPrice) {
      _state = RequestState.Error;
      _message = "Tunai Yang Diterima Belum Cukup";
      notifyListeners();
      return;
    }

    final result = await _addTransactionUseCase.execute(_carts, totalPrice, pay);
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _state = RequestState.Loaded;
        _transaction = data;
        notifyListeners();
      },
    );
  }

  void resetCart() {
    _carts = [];
    notifyListeners();
  }

  void searchProduct(String productName) {
    _filteredProducts = _products
        .where((product) => product.name.toLowerCase().contains(productName.toLowerCase()))
        .toList();
    if (_selectedTab != "") {
      _filteredProducts = _filteredProducts
          .where((product) => product.categoryId == _selectedTab)
          .toList();
    }
    notifyListeners();
  }

  void setSelectedTab(String id, String productName) {
    _selectedTab = id;
    searchProduct(productName);
  }

  void setSelectedPay(int pay) {
    _selectedPay = pay;
    notifyListeners();
  }
}
