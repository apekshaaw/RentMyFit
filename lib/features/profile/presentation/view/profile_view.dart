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
    if (photoUrl.startsWith('/')) {
      return NetworkImage('http://10.0.2.2:5000$photoUrl');
    }
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

          final profile = (state is ProfileLoadSuccess)
              ? state.profile
              : (state is ProfileUpdateSuccess ? state.profile : null);
          if (profile == null) return const SizedBox.shrink();

          return Stack(
            children: [
              // dark overlay to dismiss
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black54),
              ),
              // slide-in panel
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // close button
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // avatar + info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      _avatarProvider(profile.photoUrl),
                                  backgroundColor: Colors.white24,
                                  child: profile.photoUrl == null
                                      ? const Icon(Icons.person,
                                          size: 32, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // name + edit
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
                                            onTap: () => _showEditDialog(
                                                context, profile),
                                            child: const Icon(Icons.edit,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(profile.email,
                                          style: const TextStyle(
                                              color: Colors.white70)),
                                      if (profile.address?.isNotEmpty ==
                                          true) ...[
                                        const SizedBox(height: 4),
                                        Text(profile.address!,
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                      ],
                                      if (profile.phone?.isNotEmpty == true) ...[
                                        const SizedBox(height: 4),
                                        Text(profile.phone!,
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                      ],
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 32),

                            // ◉ Payment Methods
                            _buildMenuItem(Icons.credit_card, 'Payment Methods',
                                () => _showPaymentDialog(context)),
                            const SizedBox(height: 20),

                            // ◉ Settings
                            _buildMenuItem(
                                Icons.settings, 'Settings',
                                () => _showSettingsDialog(context)),
                            const SizedBox(height: 20),

                            // ◉ Help
                            _buildMenuItem(Icons.help_outline, 'Help',
                                () => _showHelpDialog(context)),
                            const SizedBox(height: 20),

                            // ◉ About
                            _buildMenuItem(Icons.info_outline, 'About',
                                () => _showAboutDialog(context)),
                            const Spacer(),
                            const Divider(color: Colors.white54),

                            // Log out
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Log out?'),
                                    content: const Text(
                                        'Are you sure you want to log out?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Log Out')),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: const [
                                    Icon(Icons.exit_to_app,
                                        color: Colors.white),
                                    SizedBox(width: 12),
                                    Text('LOG OUT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16)),
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

  Widget _buildMenuItem(
      IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Payment Dialog
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 12,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Powered By:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/kaltilogo.png',
                  width: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: Color(0xFFab1d79))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Settings Dialog (Update Password)
  void _showSettingsDialog(BuildContext context) {
    final currentCtl = TextEditingController();
    final newCtl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 12,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Update Password',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: currentCtl,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newCtl,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'New Password'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Dummy: no real backend yet
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password updated (dummy)')),
                    );
                  },
                  child: const Text('Change Password'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Help Dialog
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 12,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How can we help you?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'If you have any questions about your rentals, delivery, or account, '
                  'feel free to contact us anytime. We’re here to help you get the best '
                  'out of your RentMyFit experience.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Three info cards
                _helpCard(
                  icon: Icons.location_on,
                  title: 'OUR MAIN OFFICE',
                  subtitle:
                      'Mahakabhi Marg, Dillibazar,\nKathmandu, Nepal',
                ),
                const SizedBox(height: 12),
                _helpCard(
                  icon: Icons.phone,
                  title: 'PHONE NUMBER',
                  subtitle: '+977-987654321',
                ),
                const SizedBox(height: 12),
                _helpCard(
                  icon: Icons.email,
                  title: 'EMAIL',
                  subtitle: 'rentmyfitteam@gmail.com',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: Color(0xFFab1d79))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _helpCard(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFab1d79), size: 32),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // About Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: const Text('About RentMyFit'),
          content: const Text(
              'RentMyFit v1.0\n© 2025 RentMyFit Inc.\nAll rights reserved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Close', style: TextStyle(color: Color(0xFFab1d79))),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  void _showEditDialog(BuildContext context, ProfileEntity profile) {
    String? imagePath = (profile.photoUrl != null &&
            !profile.photoUrl!.startsWith('http'))
        ? profile.photoUrl
        : null;
    final picker = ImagePicker();

    final nameCtl = TextEditingController(text: profile.name);
    final emailCtl = TextEditingController(text: profile.email);
    final addressCtl =
        TextEditingController(text: profile.address ?? '');
    final phoneCtl =
        TextEditingController(text: profile.phone ?? '');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: StatefulBuilder(
          builder: (ctx, setState) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Profile',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : _avatarProvider(profile.photoUrl),
                      backgroundColor: Colors.grey[200],
                      child: imagePath == null && profile.photoUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final xfile =
                            await picker.pickImage(source: ImageSource.gallery);
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
                      decoration:
                          const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: emailCtl,
                      decoration:
                          const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: addressCtl,
                      decoration:
                          const InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: phoneCtl,
                      decoration:
                          const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final updated = ProfileEntity(
                          id: profile.id,
                          name: nameCtl.text,
                          email: emailCtl.text,
                          address: addressCtl.text.isEmpty
                              ? null
                              : addressCtl.text,
                          phone: phoneCtl.text.isEmpty
                              ? null
                              : phoneCtl.text,
                          photoUrl: imagePath,
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
