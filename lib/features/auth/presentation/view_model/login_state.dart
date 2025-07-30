import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool isAdmin;

  const LoginSuccess({this.isAdmin = false}); // ✅ Default to false

  @override
  List<Object> get props => [isAdmin];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object> get props => [message];
}
