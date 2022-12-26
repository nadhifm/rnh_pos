import 'package:dartz/dartz.dart';
import '../../commont/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signIn(String email, password);
  Future<Either<Failure, bool>> checkUser();
}