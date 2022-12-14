// ignore_for_file: use_build_context_synchronously

import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/states/auth_required_state.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/textfields.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends AuthRequiredState<JoinFamilyScreen> {
  /// username textfield controller.
  final familyCodeController = TextEditingController();

  /// The profile of the current user.
  late Profile profile;

  /// Whether data from the database is being loaded.
  bool isLoading = false;

  // For now this creates a random family of which you are the owner.
  void setupShowerButtonOnPress() async {
    Navigator.pushNamed(context, "/wifi_list");
  }

  // Join a family using the invite_code
  Future<bool> joinFamilyByCode(String code) async {
    final familyResult = await SupaBaseDatabaseService.getFamilyByCode(code);
    if (familyResult.isSuccessful) {
      profile.family = familyResult.data!.id;
      final profileResult = await SupaBaseDatabaseService.updateProfile(profile);
      if (profileResult.isSuccessful) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Join family with code present in textfield.
  void joinFamilyButtonOnPress() async {
    // Validate input.
    if (familyCodeController.text.isEmpty) {
      context.showErrorSnackBar(message: "Enter a family code");
      return;
    }
    final successfullyJoinedFamily = await joinFamilyByCode(familyCodeController.text);
    if (successfullyJoinedFamily) {
      context.showSnackBar(message: "Successfully joined family");
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      context.showErrorSnackBar(message: "Joining family failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Get the profile from the previous route.
    profile = ModalRoute.of(context)!.settings.arguments as Profile;
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
                        onTap: () {},
                        child: const Icon(
                          Icons.arrow_back,
                          size: 36,
                          color: Colors.transparent,
                        )),
                    Text(
                      "Welcome\nto Aquecius!",
                      style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    // Logout button
                    const InkWell(
                      onTap: SupaBaseAuthService.signOut,
                      child: Icon(
                        Icons.logout,
                        size: 36,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                // Page subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "If you've just bought this product and want to set it up. Click 'Setup shower' below.",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomRoundedButton(
                      text: "Setup shower",
                      onPressed: setupShowerButtonOnPress,
                      extraHorizontalPadding: 40,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "If your shower has already been setup by one of your family members, enter the family code and click 'Join family' instead.",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const Text(
                      "Family code",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Family code textfield
                    CustomTextField(
                      controller: familyCodeController,
                      hintText: "MYFAMILYCODE",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomRoundedButton(
                      text: "Join family",
                      onPressed: joinFamilyButtonOnPress,
                      extraHorizontalPadding: 40,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
