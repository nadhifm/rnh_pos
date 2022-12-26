import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/entities/product.dart';

import '../../commont/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, String>> addProduct(
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  );
  Future<Either<Failure, String>> updateProduct(
    String id,
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  );
  Future<Either<Failure, String>> deleteProduct(String id);
  Future<Either<Failure, List<Product>>> getProducts();
}
