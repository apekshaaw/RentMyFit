import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserRepository repository;

  LoginViewModel(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final user = await repository.loginUser(event.username);

    if (user == null) {
      emit(const LoginFailure(message: 'Invalid credentials'));
      return;
    }

    if (user.password == event.password) {
      emit(LoginSuccess());
    } else {
      emit(const LoginFailure(message: 'Invalid credentials'));
    }
  }
}
