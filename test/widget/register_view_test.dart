import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_view_model.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_event.dart';
import 'package:rent_my_fit/features/auth/presentation/view_model/register_state.dart';
import 'package:rent_my_fit/features/auth/presentation/view/register_view.dart';

class FakeRegisterEvent extends Fake implements RegisterEvent {}

class FakeRegisterState extends Fake implements RegisterState {}

class MockRegisterViewModel extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;

  setUpAll(() {
    registerFallbackValue(FakeRegisterEvent());
    registerFallbackValue(FakeRegisterState());
  });

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<RegisterViewModel>.value(
        value: mockRegisterViewModel,
        child: child,
      ),
    );
  }

  testWidgets('renders all inputs and button', (WidgetTester tester) async {
    when(() => mockRegisterViewModel.state).thenReturn(RegisterInitial());

    await tester.pumpWidget(buildTestableWidget(const RegisterContent(isTest: true)));

    expect(find.text('REGISTER'), findsNWidgets(2));
    expect(find.byKey(const Key('Your Name')), findsOneWidget);
    expect(find.byKey(const Key('Email address')), findsOneWidget);
    expect(find.byKey(const Key('Password')), findsOneWidget);
    expect(find.byKey(const Key('Confirm Password')), findsOneWidget);
    expect(find.text('Already have an account? Log in'), findsOneWidget);
  });
}
