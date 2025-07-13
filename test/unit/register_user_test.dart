import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late RegisterUser registerUser;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    registerUser = RegisterUser(mockRepository);
  });

  test('should call registerUser on the repository with correct user entity', () async {
    final user = UserEntity(name: 'Test User', email: 'test@example.com', password: 'password123');

    when(() => mockRepository.registerUser(user)).thenAnswer((_) async => Future.value());

    await registerUser(user);

    verify(() => mockRepository.registerUser(user)).called(1);
  });
}
