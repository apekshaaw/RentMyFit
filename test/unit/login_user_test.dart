import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late LoginUser loginUser;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    loginUser = LoginUser(mockRepository);
  });

  test('should return UserEntity when credentials are correct', () async {
    const email = 'test@example.com';
    const password = '123456';
    final user = UserEntity(name: 'Test User', email: email, password: password);

    when(() => mockRepository.loginUser(email, password))
        .thenAnswer((_) async => user);

    final result = await loginUser(email, password);

    expect(result, user);
    verify(() => mockRepository.loginUser(email, password)).called(1);
  });
}
