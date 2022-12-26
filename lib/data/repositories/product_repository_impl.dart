import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rnh_pos/commont/failure.dart';
import 'package:rnh_pos/data/datasources/product_remote_data_source.dart';
import 'package:rnh_pos/data/models/product_model.dart';
import 'package:rnh_pos/domain/entities/product.dart';
import 'package:rnh_pos/domain/repositories/product_repository.dart';

import '../../commont/exception.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> addProduct(
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  ) async {
    try {
      String newImageUrl = "";

      if (imageFile != null) {
        newImageUrl = await remoteDataSource.addImageProduct(imageFile);
      }

      final productModel = ProductModel(
        id: "",
        name: name,
        categoryId: categoryId,
        imageUrl: newImageUrl != "" ? newImageUrl : imageUrl,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        stock: stock,
      );
      final result = await remoteDataSource.addProduct(productModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(String id) async {
    try {
      final result = await remoteDataSource.deleteProduct(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      return Right(result.map((c) => c.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> updateProduct(
    String id,
    String name,
    String categoryId,
    String imageUrl,
    int purchasePrice,
    int sellingPrice,
    int stock,
    File? imageFile,
  ) async {
    try {
      String newImageUrl = "";

      if (imageFile != null) {
        newImageUrl = await remoteDataSource.addImageProduct(imageFile);
      }

      final productModel = ProductModel(
        id: id,
        name: name,
        categoryId: categoryId,
        imageUrl: newImageUrl != "" ? newImageUrl : imageUrl,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        stock: stock,
      );
      final result = await remoteDataSource.updateProduct(productModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
