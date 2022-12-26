import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:rnh_pos/data/datasources/auth_remote_data_source.dart';
import 'package:rnh_pos/data/datasources/category_remote_data_source.dart';
import 'package:rnh_pos/data/datasources/product_remote_data_source.dart';
import 'package:rnh_pos/data/datasources/transaction_remote_data_source.dart';
import 'package:rnh_pos/data/datasources/transaction_remote_data_source.dart';
import 'package:rnh_pos/data/repositories/auth_repository_impl.dart';
import 'package:rnh_pos/data/repositories/category_repository_impl.dart';
import 'package:rnh_pos/data/repositories/product_repository_impl.dart';
import 'package:rnh_pos/domain/repositories/auth_repository.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';
import 'package:rnh_pos/domain/repositories/product_repository.dart';
import 'package:rnh_pos/domain/repositories/transaction_repository.dart';
import 'package:rnh_pos/domain/repositories/transaction_repository.dart';
import 'package:rnh_pos/domain/usecases/category/add_category_use_case.dart';
import 'package:rnh_pos/domain/usecases/category/delete_category_use_case.dart';
import 'package:rnh_pos/domain/usecases/category/update_category_use_case.dart';
import 'package:rnh_pos/domain/usecases/product/add_product_use_case.dart';
import 'package:rnh_pos/domain/usecases/auth/check_user_use_case.dart';
import 'package:rnh_pos/domain/usecases/category/get_categories_use_case.dart';
import 'package:rnh_pos/domain/usecases/auth/sign_in_use_case.dart';
import 'package:rnh_pos/domain/usecases/product/delete_product_use_case.dart';
import 'package:rnh_pos/domain/usecases/product/get_products_use_case.dart';
import 'package:rnh_pos/domain/usecases/transaction/add_transaction_use_case.dart';
import 'package:rnh_pos/domain/usecases/transaction/add_transaction_use_case.dart';
import 'package:rnh_pos/domain/usecases/transaction/get_transactions_use_case.dart';
import 'package:rnh_pos/presentation/provider/add_edit_product_notifier.dart';
import 'package:rnh_pos/presentation/provider/category_notifier.dart';
import 'package:rnh_pos/presentation/provider/check_user_notifier.dart';
import 'package:rnh_pos/presentation/provider/product_notifier.dart';
import 'package:rnh_pos/presentation/provider/report_notifier.dart';
import 'package:rnh_pos/presentation/provider/sign_in_notifier.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';

import 'data/repositories/transaction_repository_impl.dart';
import 'domain/usecases/product/update_product_use_case.dart';

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
    () => SignInNotifier(locator()),
  );
  locator.registerFactory(
    () => CheckUserNotifier(locator()),
  );
  locator.registerFactory(
    () => AddEditProductNotifier(
      addProductUseCase: locator(),
      updateProductUseCase: locator(),
      getCategoriesUseCase: locator(),
      addCategoryUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => ProductNotifier(
      getCategoriesUseCase: locator(),
      getProductsUseCase: locator(),
      deleteProductUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => TransactionNotifier(
      getCategoriesUseCase: locator(),
      getProductsUseCase: locator(),
      addTransactionUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => CategoryNotifier(
      addCategoryUseCase: locator(),
      updateCategoryUseCase: locator(),
      deleteCategoryUseCase: locator(),
      getCategoriesUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => ReportNotifier(
      getTransactionsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(locator()),
  );
  locator.registerLazySingleton<CheckUserUseCase>(
    () => CheckUserUseCase(locator()),
  );
  locator.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCase(locator()),
  );
  locator.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(locator()),
  );
  locator.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(locator()),
  );
  locator.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(locator()),
  );
  locator.registerLazySingleton<AddCategoryUseCase>(
    () => AddCategoryUseCase(locator()),
  );
  locator.registerLazySingleton<UpdateCategoryUseCase>(
    () => UpdateCategoryUseCase(locator()),
  );
  locator.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(locator()),
  );
  locator.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(locator()),
  );
  locator.registerLazySingleton<AddTransactionUseCase>(
    () => AddTransactionUseCase(locator()),
  );
  locator.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(locator()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
        firestore: locator(),
        storage: locator(),
    ),
  );
  locator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(locator()),
  );

  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  locator.registerLazySingleton(() => FirebaseStorage.instance);
}
