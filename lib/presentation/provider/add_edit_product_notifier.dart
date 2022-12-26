import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rnh_pos/domain/usecases/product/add_product_use_case.dart';

import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category/add_category_use_case.dart';
import '../../domain/usecases/category/get_categories_use_case.dart';
import '../../domain/usecases/product/update_product_use_case.dart';

class AddEditProductNotifier extends ChangeNotifier {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;

  AddEditProductNotifier({
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required AddCategoryUseCase addCategoryUseCase,
  })  : _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _addCategoryUseCase = addCategoryUseCase;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  RequestState _getCategoriesState = RequestState.Empty;
  RequestState get getCategoriesState => _getCategoriesState;

  String _categoryId = '';
  String get categoryId => _categoryId;

  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<void> addProduct(
    String name,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
  ) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _addProductUseCase.execute(
      name,
      _categoryId,
      imageUrl,
      purchasePrice,
      sellingPrice,
      stock,
      _imageFile
    );
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _state = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
  }

  Future<void> updateProduct(
    String id,
    String name,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
  ) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _updateProductUseCase.execute(
      id,
      name,
      _categoryId,
      imageUrl,
      purchasePrice,
      sellingPrice,
      stock,
      _imageFile
    );
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _state = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
  }

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

  void setCategoryId(String categoryId) {
    _categoryId = categoryId;
  }

  Future<void> addCategory(String name) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _addCategoryUseCase.execute(name);
    result.fold(
          (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (message) {
        _state = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
  }

  void setImageFile(File imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  void resetImageFile() {
    _imageFile = null;
    notifyListeners();
  }
}
