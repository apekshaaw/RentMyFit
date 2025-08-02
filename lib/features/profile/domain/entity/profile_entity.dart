// lib/features/profile/domain/entity/profile_entity.dart

import 'dart:convert';

class ProfileEntity {
  final String? id;
  final String name;
  final String email;
  final String? address;
  final String? phone;
  final String? photoUrl;     // HTTP URL provided by backend (e.g. "/uploads/123.png")
  final String? photoBase64;  // Local Base64 string ready for upload

  ProfileEntity({
    this.id,
    required this.name,
    required this.email,
    this.address,
    this.phone,
    this.photoUrl,
    this.photoBase64,
  });

  /// Parse the JSON returned by GET /api/auth/profile
  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      name:      json['name']       as String,
      email:     json['email']      as String,
      address:   json['address']    as String?,
      phone:     json['phoneNumber'] as String?,
      photoUrl:  (json['profileImage'] as String?)?.isNotEmpty == true
          ? json['profileImage'] as String
          : null,
    );
  }

  /// Build the payload for updating profile.
  /// If [photoBase64] is non-null & non-empty, include it; otherwise omit it to keep the existing image.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      if (address != null)   'address': address,
      if (phone != null)     'phoneNumber': phone,
    };
    if (photoBase64 != null && photoBase64!.isNotEmpty) {
      map['profileImage'] = photoBase64;
    }
    return map;
  }

  /// Copy this entity with any fields replaced
  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? phone,
    String? photoUrl,
    String? photoBase64,
  }) {
    return ProfileEntity(
      id:           id ?? this.id,
      name:         name ?? this.name,
      email:        email ?? this.email,
      address:      address ?? this.address,
      phone:        phone ?? this.phone,
      photoUrl:     photoUrl ?? this.photoUrl,
      photoBase64:  photoBase64 ?? this.photoBase64,
    );
  }
}