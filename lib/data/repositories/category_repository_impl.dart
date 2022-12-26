import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rnh_pos/commont/failure.dart';
import 'package:rnh_pos/data/datasources/category_remote_data_source.dart';
import 'package:rnh_pos/data/models/category_model.dart';
import 'package:rnh_pos/domain/entities/category.dart';
import 'package:rnh_pos/domain/repositories/category_repository.dart';

import '../../commont/exception.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result.map((c) => c.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> addCategory(String name) async {
    try {
      final result = await remoteDataSource.addCategory(CategoryModel(
        name: name,
        id: "",
      ));
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteCategory(String id) async {
    try {
      final result = await remoteDataSource.deleteCategory(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> updateCategory(String id, String name) async {
    try {
      final result = await remoteDataSource.updateCategory(CategoryModel(
        name: name,
        id: id,
      ));
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
