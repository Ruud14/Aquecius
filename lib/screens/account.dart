import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/dropdowns.dart';
import 'package:Aquecius/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase/supabase.dart';
import 'package:Aquecius/states/auth_required_state.dart';
import 'package:Aquecius/constants.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends AuthRequiredState<AccountScreen> {
  /// username textfield controller.
  final usernameController = TextEditingController();

  /// Whether data from the database is being loaded.
  bool isLoading = true;

  /// Activity level selected in dropdown.
  ActivityLevel selectedActivityLevel = ActivityLevel.lightly_active;

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
      usernameController.text = profile!.username;
      if (profile!.activityLevel != null) {
        selectedActivityLevel = profile!.activityLevel!;
      }
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

    profile!.username = usernameController.text;
    profile!.updatedAt = DateTime.now();
    profile!.activityLevel = selectedActivityLevel;

    final response = await SupaBaseDatabaseService.updateProfile(profile!);
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
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page title row with back button.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 36,
                        )),
                    Text(
                      "About you",
                      style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
                    ),
                    // Logout button
                    const InkWell(
                        onTap: SupaBaseAuthService.signOut,
                        child: Icon(
                          Icons.logout,
                          size: 36,
                        ))
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                // Page subtitle
                Center(
                  child: Text(
                    "Enter some info about yourself to\noptimize your showers.",
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                const Text(
                  "Username",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Username textfield
                CustomTextField(
                  controller: usernameController,
                ),
                SizedBox(
                  height: 30.h,
                ),
                const Text(
                  "Physical activity level",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Physical activity level dropdown
                CustomDropdown(
                  items: <String>['sedentary', 'lightly_active', 'moderately_active', 'highly_active', 'extremely_active'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        ActivityLevel.fromName(value).dropdownString,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  value: selectedActivityLevel.name,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedActivityLevel = ActivityLevel.fromName(value);
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 100.h,
                ),
                // Save button
                Center(
                  child: PurpleButton(
                    text: "Save",
                    onPressed: updateProfile,
                    extraHorizontalPadding: 40,
                  ),
                ),
              ],
            ),
    );
  }
}
