import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rnh_pos/commont/failure.dart';
import 'package:rnh_pos/domain/repositories/auth_repository.dart';

import '../../commont/exception.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> signIn(
    String email,
    password,
  ) async {
    try {
      final result = await remoteDataSource.signIn(
        email,
        password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkUser() async {
    try {
      final result = await remoteDataSource.checkUser();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
