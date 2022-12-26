import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../commont/failure.dart';
import '../../repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  ) {
    return repository.addProduct(
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
