import 'package:flutter/cupertino.dart';
import 'package:rnh_pos/domain/entities/product.dart';

import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category/get_categories_use_case.dart';
import '../../domain/usecases/product/delete_product_use_case.dart';
import '../../domain/usecases/product/get_products_use_case.dart';

class ProductNotifier extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductNotifier({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetProductsUseCase getProductsUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _getProductsUseCase = getProductsUseCase,
        _deleteProductUseCase = deleteProductUseCase;

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

  RequestState _deleteProductState = RequestState.Empty;
  RequestState get deleteProductState => _deleteProductState;

  String _message = '';
  String get message => _message;

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

  Future<void> deleteProduct(String id) async {
    _deleteProductState = RequestState.Loading;
    notifyListeners();

    final result = await _deleteProductUseCase.execute(id);
    result.fold(
      (failure) {
        _deleteProductState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _deleteProductState = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
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
}
