import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';

class MockLoginUser extends Mock implements LoginUser {}

void main() {
  late LoginUser loginUser;

  setUpAll(() {
    registerFallbackValue(UserEntity(name: '', email: '', password: ''));
  });

  setUp(() {
    loginUser = MockLoginUser();
  });

  final testEmail = 'john@example.com';
  final testPassword = 'password123';
  final testUser = UserEntity(
    name: 'John Doe',
    email: testEmail,
    password: testPassword,
  );

  group('LoginViewModel', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        when(() => loginUser.call(testEmail, testPassword))
            .thenAnswer((_) async => testUser);
        return LoginViewModel(loginUser);
      },
      act: (bloc) => bloc.add(LoginButtonPressed(
        username: testEmail,
        password: testPassword,
      )),
      expect: () => [
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginLoading, LoginFailure] when login fails',
      build: () {
        when(() => loginUser.call(testEmail, testPassword))
            .thenAnswer((_) async => null);
        return LoginViewModel(loginUser);
      },
      act: (bloc) => bloc.add(LoginButtonPressed(
        username: testEmail,
        password: testPassword,
      )),
      expect: () => [
        LoginLoading(),
        isA<LoginFailure>(),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginLoading, LoginFailure] when login throws exception',
      build: () {
        when(() => loginUser.call(testEmail, testPassword))
            .thenThrow(Exception('Server error'));
        return LoginViewModel(loginUser);
      },
      act: (bloc) => bloc.add(LoginButtonPressed(
        username: testEmail,
        password: testPassword,
      )),
      expect: () => [
        LoginLoading(),
        isA<LoginFailure>(),
      ],
    );
  });
}
