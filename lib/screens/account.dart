import 'package:flutter/material.dart';
import 'package:showerthing/models/profile.dart';
import 'package:showerthing/services/supabase_auth.dart';
import 'package:showerthing/services/supabase_database.dart';
import 'package:showerthing/wrappers/scrollable_page.dart';
import 'package:supabase/supabase.dart';
import 'package:showerthing/states/auth_required_state.dart';
import 'package:showerthing/constants.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends AuthRequiredState<AccountScreen> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  var _loading = false;

  /// Get the profile from the database.
  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await SupaBaseDatabaseService.getProfile(userId);
    if (response.isSuccessful) {
      final profile = Profile.fromJson(userId, response.data);
      _usernameController.text = profile.username;
      _websiteController.text = profile.website;
    } else {
      if (mounted) {
        context.showErrorSnackBar(message: response.message ?? "Getting profile failed.");
      }
    }
    setState(() {
      _loading = false;
    });
  }

  /// Update the profile in the database.
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    final profile = Profile(
      id: supabase.auth.currentUser!.id,
      username: _usernameController.text,
      website: _websiteController.text,
      updatedAt: DateTime.now().toIso8601String(),
    );

    final response = await SupaBaseDatabaseService.updateProfile(profile);
    if (mounted) {
      if (response.isSuccessful) {
        context.showSnackBar(message: "Successfully updated profile!");
      } else {
        context.showErrorSnackBar(message: response.message ?? "Getting profile failed.");
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    final response = await SupaBaseAuthService.signOut();
    if (!response.isSuccessful && mounted) {
      context.showErrorSnackBar(message: response.message ?? "SignOut failed.");
    }
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _updateProfile, child: Text(_loading ? 'Saving...' : 'Update')),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _signOut, child: const Text('Sign Out')),
        ],
      ),
    );
  }
}
