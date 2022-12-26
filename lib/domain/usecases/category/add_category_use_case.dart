import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/category.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);


  Future<Either<Failure, String>> execute(String name) {
    return repository.addCategory(name);
  }
}