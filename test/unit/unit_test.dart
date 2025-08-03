// test/unit/unit_tests_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/app/service_locator.dart' as serviceLocator;
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LoginViewModel Bloc Tests (4 tests)
/// ─────────────────────────────────────────────────────────────────────────────

class MockLoginUser extends Mock implements LoginUser {}
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  group('LoginViewModel Bloc Tests', () {
    late LoginViewModel bloc;
    late MockLoginUser mockLoginUser;

    setUp(() {
      mockLoginUser = MockLoginUser();
      bloc = LoginViewModel(mockLoginUser);
    });

    tearDown(() {
      serviceLocator.authToken = '';
    });

    test('1) initial state is LoginInitial', () {
      expect(bloc.state, isA<LoginInitial>());
    });

    blocTest<LoginViewModel, LoginState>(
      '2) emits [Loading, Success] when loginUser returns a valid UserEntity',
      setUp: () {
        when(() => mockLoginUser.call('john', 'pass')).thenAnswer(
          (_) async => UserEntity(
            id: '1',
            name: 'John',
            email: 'john@example.com',
            password: 'pass',
            isAdmin: false,
            token: 'tok123',
          ),
        );
      },
      build: () => bloc,
      act: (b) => b.add(const LoginButtonPressed(username: 'john', password: 'pass')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>().having((s) => s.user.email, 'email', 'john@example.com'),
      ],
      verify: (_) {
        expect(serviceLocator.authToken, 'tok123');
      },
    );

    blocTest<LoginViewModel, LoginState>(
      '3) emits [Loading, Failure] when loginUser returns null',
      setUp: () {
        when(() => mockLoginUser.call(any(), any())).thenAnswer((_) async => null);
      },
      build: () => bloc,
      act: (b) => b.add(const LoginButtonPressed(username: 'any', password: 'any')),
      expect: () => [
        isA<LoginLoading>(),
        const LoginFailure(message: 'Invalid credentials'),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      '4) emits [Loading, Failure] when loginUser throws',
      setUp: () {
        when(() => mockLoginUser.call(any(), any()))
            .thenThrow(Exception('network error'));
      },
      build: () => bloc,
      act: (b) => b.add(const LoginButtonPressed(username: 'u', password: 'p')),
      expect: () => [
        isA<LoginLoading>(),
        predicate<LoginState>((state) =>
            state is LoginFailure &&
            state.message.contains('Exception: network error')),
      ],
    );
  });

  /// ────────────────────────────────────────────────────────────────────────────
  /// ProductModel Unit Tests (3 tests)
  /// ────────────────────────────────────────────────────────────────────────────

  group('ProductModel Unit Tests', () {
    test('5) fromJson parses all fields correctly', () {
      final json = {
        '_id': '123',
        'name': 'Sneaker',
        'description': 'Comfortable shoe',
        'category': 'shoes',
        'sizes': ['8', '9', '10'],
        'imageUrl': 'http://img',
        'price': 79.99,
      };
      final p = ProductModel.fromJson(json);
      expect(p.id, '123');
      expect(p.name, 'Sneaker');
      expect(p.category, 'shoes');
      expect(p.sizes, ['8', '9', '10']);
      expect(p.imageUrl, 'http://img');
      expect(p.price, 79.99);
    });

    test('6) toJson returns correct map (omits _id)', () {
      final p = ProductModel(
        id: 'x1',
        name: 'Boot',
        description: 'Warm boot',
        category: 'shoes',
        sizes: ['7', '8'],
        imageUrl: 'u',
        price: 120.0,
      );
      final m = p.toJson();
      expect(m, {
        'name': 'Boot',
        'description': 'Warm boot',
        'category': 'shoes',
        'sizes': ['7', '8'],
        'imageUrl': 'u',
        'price': 120.0,
      });
    });

    test('7) fromJson handles missing sizes and price null', () {
      final json = {
        '_id': 'no',
        'name': 'Hat',
        'description': 'Wool hat',
        'category': 'clothing',
        // sizes and price missing
      };
      final p = ProductModel.fromJson(json);
      expect(p.id, 'no');
      expect(p.sizes, isEmpty);
      expect(p.price, 0.0);
    });
  });

  /// ────────────────────────────────────────────────────────────────────────────
  /// UserHiveModel Unit Tests (3 tests, including new round-trip)
  /// ────────────────────────────────────────────────────────────────────────────

  group('UserHiveModel Unit Tests', () {
    test('8) toEntity maps fields correctly', () {
      final hive = UserHiveModel(
        name: 'Alice',
        email: 'a@a.com',
        password: 'pw',
        token: 'tkn',
      );
      final entity = hive.toEntity();
      expect(entity.name, 'Alice');
      expect(entity.email, 'a@a.com');
      expect(entity.password, 'pw');
      expect(entity.token, 'tkn');
    });

    test('9) fromEntity maps fields correctly', () {
      final user = UserEntity(
        id: 'id1',
        name: 'Bob',
        email: 'b@b.com',
        password: 'pw2',
        isAdmin: true,
        token: 'tok2',
      );
      final hive = UserHiveModel.fromEntity(user);
      expect(hive.name, 'Bob');
      expect(hive.email, 'b@b.com');
      expect(hive.password, 'pw2');
      expect(hive.token, 'tok2');
    });

    test('10) round-trip: fromEntity then toEntity yields identical UserEntity', () {
      final original = UserEntity(
        id: 'xyz',
        name: 'Carol',
        email: 'c@c.com',
        password: 'passX',
        isAdmin: false,
        token: 'tokenX',
      );
      // to Hive model then back to entity:
      final hive = UserHiveModel.fromEntity(original);
      final roundTrip = hive.toEntity();
      expect(roundTrip.name, original.name);
      expect(roundTrip.email, original.email);
      expect(roundTrip.password, original.password);
      expect(roundTrip.token, original.token);
    });
  });
}
