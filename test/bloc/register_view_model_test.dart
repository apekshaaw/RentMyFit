import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';

class MockRegisterUser extends Mock implements RegisterUser {}

void main() {
  late RegisterUser registerUser;

  setUpAll(() {
    registerFallbackValue(UserEntity(name: '', email: '', password: ''));
  });

  setUp(() {
    registerUser = MockRegisterUser();
  });

  final testUser = UserEntity(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
  );

  group('RegisterViewModel', () {
    blocTest<RegisterViewModel, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] when register is successful',
      build: () {
        when(() => registerUser.call(any())).thenAnswer((_) async {});
        return RegisterViewModel(registerUser);
      },
      act: (bloc) => bloc.add(RegisterButtonPressed(
        name: testUser.name,
        email: testUser.email,
        password: testUser.password,
      )),
      expect: () => [
        RegisterLoading(),
        RegisterSuccess(),
      ],
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [RegisterLoading, RegisterFailure] when register throws exception',
      build: () {
        when(() => registerUser.call(any()))
            .thenThrow(Exception('Registration Failed'));
        return RegisterViewModel(registerUser);
      },
      act: (bloc) => bloc.add(RegisterButtonPressed(
        name: testUser.name,
        email: testUser.email,
        password: testUser.password,
      )),
      expect: () => [
        RegisterLoading(),
        isA<RegisterFailure>(),
      ],
    );
  });
}
