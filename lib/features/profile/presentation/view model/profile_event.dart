import 'package:equatable/equatable.dart';
import '../../domain/entity/profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger loading the current profile
class LoadProfile extends ProfileEvent {}

/// Trigger updating the profile
class UpdateProfileEvent extends ProfileEvent {
  final ProfileEntity profile;
  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
