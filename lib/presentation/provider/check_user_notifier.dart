import 'package:flutter/widgets.dart';
import 'package:rnh_pos/domain/usecases/auth/check_user_use_case.dart';

import '../../commont/state_enum.dart';

class CheckUserNotifier extends ChangeNotifier {
  final CheckUserUseCase _checkUserUseCase;

  CheckUserNotifier(this._checkUserUseCase);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  Future<void> checkUser() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _checkUserUseCase.execute();

    result.fold(
      (failure) {
        _state = RequestState.Error;
        notifyListeners();
      },
      (result) {
        if (result) {
          _state = RequestState.Loaded;
          notifyListeners();
        } else {
          _state = RequestState.Error;
          notifyListeners();
        }
      },
    );
  }
}
