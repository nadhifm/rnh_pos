import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/entities/category.dart';

import '../../commont/failure.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addCategory(String name);
  Future<Either<Failure, String>> updateCategory(String id, String name);
  Future<Either<Failure, String>> deleteCategory(String id);
  Future<Either<Failure, List<Category>>> getCategories();
}