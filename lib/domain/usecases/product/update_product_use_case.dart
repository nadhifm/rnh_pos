import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../commont/failure.dart';
import '../../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    String id,
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  ) {
    return repository.updateProduct(
      id,
      name,
      categoryId,
      imageUrl,
      purchasePrice,
      sellingPrice,
      stock,
      imageFile,
    );
  }
}
