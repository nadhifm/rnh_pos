import 'package:dartz/dartz.dart';

import '../../../commont/failure.dart';
import '../../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, String>> execute(String id) {
    return repository.deleteProduct(id);
  }
}
