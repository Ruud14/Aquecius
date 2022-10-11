import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/states/auth_required_state.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinOrCreateFamilyScreen extends StatefulWidget {
  const JoinOrCreateFamilyScreen({super.key});

  @override
  State<JoinOrCreateFamilyScreen> createState() => _JoinOrCreateFamilyScreenState();
}

class _JoinOrCreateFamilyScreenState extends AuthRequiredState<JoinOrCreateFamilyScreen> {
  /// Whether data from the database is being loaded.
  bool isLoading = false;

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
                      "If you you've just bought this product and want to set it up. Click 'Setup shower' below.",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    PurpleButton(
                      text: "Setup shower",
                      onPressed: () {},
                      extraHorizontalPadding: 40,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "If your shower has already been setup by one of your family members, click 'Join family' instead.",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    PurpleButton(
                      text: "Join family",
                      onPressed: () {},
                      extraHorizontalPadding: 40,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
