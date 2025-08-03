// test/register_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';

// 1️⃣ Mock the use-case
class MockRegisterUser extends Mock implements RegisterUser {}

// 2️⃣ Fake for UserEntity so mocktail can use any<UserEntity>()
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  // 3️⃣ Register the fake before any tests run
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  group('RegisterViewModel Bloc Tests', () {
    late RegisterViewModel bloc;
    late MockRegisterUser mockRegister;

    setUp(() {
      mockRegister = MockRegisterUser();
      bloc = RegisterViewModel(mockRegister);
    });

    test('1) initial state is RegisterInitial', () {
      expect(bloc.state, isA<RegisterInitial>());
    });

    blocTest<RegisterViewModel, RegisterState>(
  'emits [Loading, Success] and passes correct UserEntity to use-case',
  setUp: () {
    when(() => mockRegister.call(any<UserEntity>()))
      .thenAnswer((_) async {});
  },
  build: () => bloc,
  act: (b) => b.add(const RegisterButtonPressed(
    name: 'Alice',
    email: 'alice@test.com',
    password: 'password',
  )),
  expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
  verify: (_) {
    final v = verify(() => mockRegister.call(captureAny<UserEntity>()));
    v.called(1);
    final entity = v.captured.first as UserEntity;
    expect(entity.name, 'Alice');
    expect(entity.email, 'alice@test.com');
    expect(entity.password, 'password');
  },
);


    blocTest<RegisterViewModel, RegisterState>(
      '3) emits [Loading, Failure] when registerUser throws',
      setUp: () {
        when(() => mockRegister.call(any<UserEntity>()))
            .thenThrow(Exception('oops'));
      },
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(
        name: 'Bob',
        email: 'bob@test.com',
        password: '1234',
      )),
      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],
      verify: (_) => verify(() => mockRegister.call(any<UserEntity>())).called(1),
    );

    blocTest<RegisterViewModel, RegisterState>(
      '4) can handle two sequential RegisterButtonPressed events',
      setUp: () {
        when(() => mockRegister.call(any<UserEntity>()))
            .thenAnswer((_) async {});
      },
      build: () => bloc,
      act: (b) async {
        b
          ..add(const RegisterButtonPressed(name: 'X', email: 'x@x.com', password: 'p'))
          ..add(const RegisterButtonPressed(name: 'Y', email: 'y@y.com', password: 'q'));
      },
      expect: () => [
        isA<RegisterLoading>(), isA<RegisterSuccess>(),
        isA<RegisterLoading>(), isA<RegisterSuccess>(),
      ],
    );

    blocTest<RegisterViewModel, RegisterState>(
      '5) emits nothing if no events are added',
      build: () => bloc,
      expect: () => const <RegisterState>[],
    );

    blocTest<RegisterViewModel, RegisterState>(
      '6) empty name still calls use-case (success)',
      setUp: () => when(() => mockRegister.call(any<UserEntity>())).thenAnswer((_) async {}),
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(name: '', email: 'e@e.com', password: 'p')),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
    );

    blocTest<RegisterViewModel, RegisterState>(
      '7) empty email still calls use-case (success)',
      setUp: () => when(() => mockRegister.call(any<UserEntity>())).thenAnswer((_) async {}),
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(name: 'N', email: '', password: 'p')),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
    );

    blocTest<RegisterViewModel, RegisterState>(
      '8) empty password still calls use-case (success)',
      setUp: () => when(() => mockRegister.call(any<UserEntity>())).thenAnswer((_) async {}),
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(name: 'N', email: 'e@e.com', password: '')),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
    );

    blocTest<RegisterViewModel, RegisterState>(
      '9) use-case is invoked exactly once per event',
      setUp: () => when(() => mockRegister.call(any<UserEntity>())).thenAnswer((_) async {}),
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(name: 'One', email: '1@1.com', password: '1')),
      verify: (_) => verify(() => mockRegister.call(any<UserEntity>())).called(1),
    );

    blocTest<RegisterViewModel, RegisterState>(
      '10) failure state carries exception message',
      setUp: () {
        when(() => mockRegister.call(any<UserEntity>()))
            .thenThrow(Exception('bad'));
      },
      build: () => bloc,
      act: (b) => b.add(const RegisterButtonPressed(name: 'Bad', email: 'b@b.com', password: 'x')),
      expect: () => [
        isA<RegisterLoading>(),
        predicate<RegisterState>((state) =>
          state is RegisterFailure && state.message.contains('bad')
        ),
      ],
    );
  });
}
