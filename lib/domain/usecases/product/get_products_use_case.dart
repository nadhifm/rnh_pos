import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/entities/product.dart';

import '../../../commont/failure.dart';
import '../../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> execute() {
    return repository.getProducts();
  }
}
