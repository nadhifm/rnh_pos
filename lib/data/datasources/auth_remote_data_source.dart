import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rnh_pos/commont/exception.dart';

abstract class AuthRemoteDataSource {
  Future<String> signIn(String email, password);
  Future<bool> checkUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl(this.auth);

  @override
  Future<String> signIn(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sign In Berhasil";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ServerException('Email Anda Belum Terdaftar');
      } else if (e.code == 'wrong-password') {
        throw ServerException('Password Salah');
      }
    }

    throw ServerException("Terjadi Kesalaha");
  }

  @override
  Future<bool> checkUser() async {
    final user = auth.currentUser;

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
