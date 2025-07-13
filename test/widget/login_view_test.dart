import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/login_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/login_view_model.dart';

void main() {
  late LoginUser loginUser;

  setUp(() {
    loginUser = _TestLoginUser();
  });

  testWidgets('LoginView shows success snackbar on correct login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (_) => LoginViewModel(loginUser),
            child: const LoginContent(isTest: true),
          ),
        ),
      ),
    );

    // Enter valid email and password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');

    // Tap the login button
    await tester.tap(find.text('LOG IN'));
    await tester.pump(); // Process the tap event
    await tester.pump(const Duration(seconds: 1)); // Allow SnackBar to show

    // Verify the SnackBar appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('You are logged in'), findsOneWidget);
  });
}

class _TestLoginUser extends LoginUser {
  _TestLoginUser() : super(_FakeUserRepo());

  @override
  Future<UserEntity?> call(String email, String password) async {
    if (email == 'test@example.com' && password == '123456') {
      return UserEntity(
        name: 'Test User',
        email: email,
        password: password,
      );
    }
    return null;
  }
}

class _FakeUserRepo extends Fake implements UserRepository {
  @override
  Future<UserEntity> loginUser(String email, String password) async {
    if (email == 'test@example.com' && password == '123456') {
      return UserEntity(
        name: 'Test User',
        email: email,
        password: password,
      );
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> registerUser(UserEntity user) async {}
}
