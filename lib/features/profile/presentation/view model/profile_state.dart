import 'package:equatable/equatable.dart';
import '../../domain/entity/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final ProfileEntity profile;
  const ProfileLoadSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadFailure extends ProfileState {
  final String message;
  const ProfileLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateInProgress extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;
  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateFailure extends ProfileState {
  final String message;
  const ProfileUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
