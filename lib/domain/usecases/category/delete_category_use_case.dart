import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/category.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);


  Future<Either<Failure, String>> execute(String id) {
    return repository.deleteCategory(id);
  }
}