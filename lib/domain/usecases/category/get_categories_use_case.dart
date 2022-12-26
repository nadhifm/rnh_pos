import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/category.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);


  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}