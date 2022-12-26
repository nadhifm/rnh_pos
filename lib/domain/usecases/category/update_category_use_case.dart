import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/category.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);


  Future<Either<Failure, String>> execute(String id, String name) {
    return repository.updateCategory(id, name);
  }
}