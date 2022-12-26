import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/auth_repository.dart';

import '../../../commont/failure.dart';

class CheckUserUseCase {
  final AuthRepository repository;

  CheckUserUseCase(this.repository);

  Future<Either<Failure, bool>> execute() {
    return repository.checkUser();
  }
}