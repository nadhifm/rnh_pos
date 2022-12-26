import 'package:flutter/widgets.dart';
import 'package:rnh_pos/domain/usecases/auth/sign_in_use_case.dart';

import '../../commont/state_enum.dart';

class SignInNotifier extends ChangeNotifier {
  final SignInUseCase _signInUseCase;

  SignInNotifier(this._signInUseCase);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> signIn(String email, password) async {
    final result = await _signInUseCase.execute(email, password);
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _state = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
  }
}
