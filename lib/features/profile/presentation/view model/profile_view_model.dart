// lib/features/profile/presentation/view_model/profile_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  ProfileViewModel(this._getProfile, this._updateProfile)
      : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadInProgress());
    try {
      final profile = await _getProfile();
      if (profile == null) {
        emit(ProfileLoadFailure('No profile found'));
      } else {
        emit(ProfileLoadSuccess(profile));
      }
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdateInProgress());
    try {
      // 1) Push update to server
      await _updateProfile(event.profile);

      // 2) Re-fetch the updated profile
      final refreshedProfile = await _getProfile();
      if (refreshedProfile == null) {
        emit(ProfileLoadFailure('Profile updated, but fetching failed'));
      } else {
        // 3) Notify listener to close dialog
        emit(ProfileUpdateSuccess(refreshedProfile));
        // 4) Then emit load success so UI rebuilds
        emit(ProfileLoadSuccess(refreshedProfile));
      }
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }
}
