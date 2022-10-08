import 'package:flutter/material.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:supabase/supabase.dart';
import 'package:Aquecius/states/auth_required_state.dart';
import 'package:Aquecius/constants.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends AuthRequiredState<AccountScreen> {
  final _usernameController = TextEditingController();
  var isLoading = false;

  /// The profile of the current user.
  Profile? profile;

  /// Get the profile from the database.
  Future<void> getProfile(String userId) async {
    setState(() {
      isLoading = true;
    });

    // Get the user data.
    final profileFetchResult = await SupaBaseDatabaseService.getProfile(SupaBaseAuthService.uid!);
    if (profileFetchResult.isSuccessful) {
      profile = profileFetchResult.data;
      _usernameController.text = profile!.username;
    } else {
      if (mounted) {
        context.showErrorSnackBar(message: "Could not fetch profile ${profileFetchResult.message}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Update the profile in the database.
  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    final profile = Profile(
      id: supabase.auth.currentUser!.id,
      username: _usernameController.text,
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
      isLoading = false;
    });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
          const SizedBox(height: 18),
          ElevatedButton(
              onPressed: updateProfile,
              child: Text(
                isLoading ? 'Saving...' : 'Update',
                style: const TextStyle(color: Colors.white),
              )),
          const SizedBox(height: 18),
          const ElevatedButton(
              onPressed: SupaBaseAuthService.signOut,
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
