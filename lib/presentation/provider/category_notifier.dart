import 'package:flutter/cupertino.dart';
import 'package:rnh_pos/domain/entities/category.dart';
import 'package:rnh_pos/domain/usecases/category/get_categories_use_case.dart';

import '../../commont/state_enum.dart';
import '../../domain/usecases/category/add_category_use_case.dart';
import '../../domain/usecases/category/delete_category_use_case.dart';
import '../../domain/usecases/category/update_category_use_case.dart';

class CategoryNotifier extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoryNotifier({
    required GetCategoriesUseCase getCategoriesUseCase,
    required AddCategoryUseCase addCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _addCategoryUseCase = addCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase;

  List<Category> _categories = [];

  List<Category> _filteredCategories = [];
  List<Category> get filteredCategories => _filteredCategories;

  RequestState _getCategoriesState = RequestState.Empty;
  RequestState get getCategoriesState => _getCategoriesState;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

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
        _filteredCategories = _categories;
        notifyListeners();
      },
    );
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

  Future<void> updateCategory(String id, String name) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _updateCategoryUseCase.execute(id, name);
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

  Future<void> deleteCategory(String id) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _deleteCategoryUseCase.execute(id);
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

  void searchCategory(String categoryName) {
    _filteredCategories = _categories
        .where((category) =>
            category.name.toLowerCase().contains(categoryName.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
