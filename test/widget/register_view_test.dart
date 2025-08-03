// test/widgets/register_view_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rent_my_fit/app/service_locator.dart' as sl;
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/usecases/register_user.dart';
import 'package:rent_my_fit/features/auth/presentation/view/register_view.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';

class MockRegisterUser extends Mock implements RegisterUser {}
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockRegisterUser mockRegister;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeUserEntity());
    FlutterError.onError = (_) {};
  });

  setUp(() {
    mockRegister = MockRegisterUser();
    sl.sl.registerSingleton<RegisterUser>(mockRegister);
  });

  tearDown(() {
    sl.sl.reset();
  });

  Future<void> pumpRegister(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RegisterViewModel>(
          create: (_) => RegisterViewModel(mockRegister),
          child: const RegisterView(isTest: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RegisterView Widget Tests', () {
    testWidgets('1) shows all form fields and REGISTER button', (tester) async {
      await pumpRegister(tester);
      expect(find.byKey(const Key('Your Name')), findsOneWidget);
      expect(find.byKey(const Key('Email address')), findsOneWidget);
      expect(find.byKey(const Key('Password')), findsOneWidget);
      expect(find.byKey(const Key('Confirm Password')), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'REGISTER'), findsOneWidget);
    });

    testWidgets('2) allows text entry in all fields', (tester) async {
      await pumpRegister(tester);
      await tester.enterText(find.byKey(const Key('Your Name')), 'Alice');
      await tester.enterText(find.byKey(const Key('Email address')), 'a@b.com');
      await tester.enterText(find.byKey(const Key('Password')), 'pw');
      await tester.enterText(find.byKey(const Key('Confirm Password')), 'pw');
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('a@b.com'), findsOneWidget);
      expect(find.text('pw'), findsNWidgets(2));
    });

    testWidgets('3) mismatched passwords show error SnackBar', (tester) async {
      await pumpRegister(tester);
      await tester.enterText(find.byKey(const Key('Password')), 'one');
      await tester.enterText(
          find.byKey(const Key('Confirm Password')), 'two');
      final btn = find.widgetWithText(ElevatedButton, 'REGISTER');
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('4) successful register shows success SnackBar', (tester) async {
      when(() => mockRegister.call(any<UserEntity>()))
          .thenAnswer((_) async {});
      await pumpRegister(tester);
      await tester.enterText(find.byKey(const Key('Your Name')), 'Bob');
      await tester.enterText(
          find.byKey(const Key('Email address')), 'b@b.com');
      await tester.enterText(find.byKey(const Key('Password')), 'pw');
      await tester.enterText(
          find.byKey(const Key('Confirm Password')), 'pw');
      final btn = find.widgetWithText(ElevatedButton, 'REGISTER');
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();
      expect(find.text('User registered'), findsOneWidget);
    });

    testWidgets('5) failed register shows exception SnackBar', (tester) async {
      when(() => mockRegister.call(any<UserEntity>()))
          .thenThrow(Exception('fail'));
      await pumpRegister(tester);
      await tester.enterText(find.byKey(const Key('Your Name')), 'Carol');
      await tester.enterText(
          find.byKey(const Key('Email address')), 'c@c.com');
      await tester.enterText(find.byKey(const Key('Password')), 'pw');
      await tester.enterText(
          find.byKey(const Key('Confirm Password')), 'pw');
      final btn = find.widgetWithText(ElevatedButton, 'REGISTER');
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();
      expect(find.textContaining('Exception: fail'), findsOneWidget);
    });

    testWidgets('6) password fields are obscured', (tester) async {
      await pumpRegister(tester);
      final pw =
          tester.widget<TextField>(find.byKey(const Key('Password')));
      final cpw = tester
          .widget<TextField>(find.byKey(const Key('Confirm Password')));
      expect(pw.obscureText, isTrue);
      expect(cpw.obscureText, isTrue);
    });

    testWidgets('7) form is wrapped in SingleChildScrollView', (tester) async {
      await pumpRegister(tester);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('8) "Already have an account? Log in" link is present',
        (tester) async {
      await pumpRegister(tester);
      final link = find.textContaining('Already have an account?');
      expect(link, findsOneWidget);
      expect(
        find.ancestor(of: link, matching: find.byType(GestureDetector)),
        findsOneWidget,
      );
    });

    testWidgets(
      '9) tapping REGISTER with empty inputs still calls use-case with empty UserEntity',
      (tester) async {
        when(() => mockRegister.call(any<UserEntity>()))
            .thenAnswer((_) async {});
        await pumpRegister(tester);
        final btn = find.widgetWithText(ElevatedButton, 'REGISTER');
        await tester.ensureVisible(btn);
        await tester.tap(btn);
        await tester.pumpAndSettle();
        final v = verify(() => mockRegister.call(captureAny<UserEntity>()));
        v.called(1);
        final u = v.captured.first as UserEntity;
        expect(u.name, '');
        expect(u.email, '');
        expect(u.password, '');
      });

    testWidgets('10) back arrow icon is present', (tester) async {
      await pumpRegister(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
