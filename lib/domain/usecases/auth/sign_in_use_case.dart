import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/auth_repository.dart';

import '../../../commont/failure.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    String email,
    password,
  ) {
    return repository.signIn(email, password);
  }
}
