import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_event.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_state.dart';
import 'package:rent_my_fit/features/profile/presentation/view%20model/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  ImageProvider<Object>? _avatarProvider(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return null;
    if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    }
    // handle relative URLs from backend
    if (photoUrl.startsWith('/')) {
      return NetworkImage('http://10.0.2.2:5000$photoUrl');
    }
    // otherwise assume Base64
    return MemoryImage(base64Decode(photoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.read<ProfileViewModel>().add(LoadProfile());
        }
        if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update failed: ${state.message}')),
          );
          context.read<ProfileViewModel>().add(LoadProfile());
        }
      },
      child: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileViewModel>().add(LoadProfile());
            return const SizedBox.shrink();
          }
          if (state is ProfileLoadInProgress ||
              state is ProfileUpdateInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoadFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }

          ProfileEntity? profile;

          if (state is ProfileLoadSuccess) {
            profile = state.profile;
          } else if (state is ProfileUpdateSuccess) {
            profile = state.profile;
          } else {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black54),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: _avatarProvider(
                                    profile.photoUrl,
                                  ),
                                  backgroundColor: Colors.white24,
                                  child:
                                      profile.photoUrl == null
                                          ? const Icon(
                                            Icons.person,
                                            size: 32,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              profile.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:
                                                () => _showEditDialog(
                                                  context,
                                                  profile!,
                                                ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        profile.email,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (profile.address != null &&
                                          profile.address!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          profile.address!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      if (profile.phone != null &&
                                          profile.phone!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          profile.phone!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildMenuItem(
                              Icons.credit_card,
                              'Payment Methods',
                              () {},
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(Icons.settings, 'Settings', () {}),
                            const SizedBox(height: 20),
                            _buildMenuItem(Icons.help_outline, 'Help', () {}),
                            const SizedBox(height: 20),
                            _buildMenuItem(Icons.info_outline, 'About', () {}),
                            const Spacer(),
                            const Divider(color: Colors.white54),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: const Text('Log out?'),
                                        content: const Text(
                                          'Are you sure you want to log out?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Log Out'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'LOG OUT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProfileEntity profile) {
    // If profile.photoUrl is already a local path, keep it; otherwise start null
    String? imagePath =
        (profile.photoUrl != null && !profile.photoUrl!.startsWith('http'))
            ? profile.photoUrl
            : null;
    final picker = ImagePicker();

    final nameCtl = TextEditingController(text: profile.name);
    final emailCtl = TextEditingController(text: profile.email);
    final addressCtl = TextEditingController(text: profile.address ?? '');
    final phoneCtl = TextEditingController(text: profile.phone ?? '');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: StatefulBuilder(
              builder:
                  (ctx, setState) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    insetPadding: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Live preview from local file if present, else from network/Base64
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: imagePath != null
    ? FileImage(File(imagePath!))
    : _avatarProvider(profile.photoUrl),
                              backgroundColor: Colors.grey[200],
                              child:
                                  imagePath == null && profile.photoUrl == null
                                      ? const Icon(Icons.person, size: 40)
                                      : null,
                            ),
                            const SizedBox(height: 12),

                            ElevatedButton(
                              onPressed: () async {
                                final xfile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (xfile != null) {
                                  setState(() {
                                    imagePath = xfile.path;
                                  });
                                }
                              },
                              child: const Text('Upload Image'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  imagePath = null;
                                });
                              },
                              child: const Text('Remove Image'),
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              controller: nameCtl,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextField(
                              controller: emailCtl,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            TextField(
                              controller: addressCtl,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                              ),
                            ),
                            TextField(
                              controller: phoneCtl,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                final updated = ProfileEntity(
                                  id: profile.id,
                                  name: nameCtl.text,
                                  email: emailCtl.text,
                                  address:
                                      addressCtl.text.isEmpty
                                          ? null
                                          : addressCtl.text,
                                  phone:
                                      phoneCtl.text.isEmpty
                                          ? null
                                          : phoneCtl.text,
                                  photoUrl: imagePath, // pass local file path
                                );
                                context.read<ProfileViewModel>().add(
                                  UpdateProfileEvent(updated),
                                );
                              },
                              child: const Text('Update'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ),
    );
  }
}
