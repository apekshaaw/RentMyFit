import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository repository;

  RegisterViewModel(this.repository) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final user = UserEntity(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      await repository.registerUser(user);

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(message: e.toString()));
    }
  }
}
