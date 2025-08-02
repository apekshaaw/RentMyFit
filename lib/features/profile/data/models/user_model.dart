import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? address;
  final String? phone;
  final String? photoUrl;
  final String? photoBase64;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.address,
    this.phone,
    this.photoUrl,
    this.photoBase64,
  });

  // Convert from JSON (API response) to model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      photoUrl: json['profilePic'], // Assuming backend sends this as profilePic
    );
  }

  // Convert from model to JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'profilePic': photoBase64, // Send base64 to backend
    };
  }

  // Convert from model to entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      address: address,
      phone: phone,
      photoUrl: photoUrl,
      photoBase64: photoBase64,
    );
  }

  // Convert from entity to model
  static UserModel fromEntity(ProfileEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      address: entity.address,
      phone: entity.phone,
      photoUrl: entity.photoUrl,
      photoBase64: entity.photoBase64,
    );
  }
}
