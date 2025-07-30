import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
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
      final UserEntity? user = await loginUser(event.username, event.password);

      if (user != null) {
        emit(LoginSuccess(user: user)); // ✅ send whole user object
      } else {
        emit(const LoginFailure(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}
