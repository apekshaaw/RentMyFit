import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;

  LoginViewModel(this.loginUser) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final user = await loginUser(event.username, event.password);

      if (user != null) {
        emit(LoginSuccess());
      } else {
        emit(const LoginFailure(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}
