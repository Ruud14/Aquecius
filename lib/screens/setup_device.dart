import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/family.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/textfields.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

class SetupDeviceScreen extends StatefulWidget {
  const SetupDeviceScreen({super.key});

  @override
  State<SetupDeviceScreen> createState() => _SetupDeviceScreenState();
}

class _SetupDeviceScreenState extends State<SetupDeviceScreen> {
  late String ssid;
  late String password;

  late Family family;

  String urlToLaunch = "http://google.com";

  /// username textfield controller.
  final inviteCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Create the family container.
    family = Family(id: null, creator: SupaBaseAuthService.uid!, inviteCode: '', isShowering: null);
  }

  // Join a family using the invite_code
  Future<bool> joinFamilyByCode(String code) async {
    final profileResult = await SupaBaseDatabaseService.getProfile(SupaBaseAuthService.uid!);
    if (!profileResult.isSuccessful) {
      return false;
    }
    final profile = profileResult.data;
    final familyResult = await SupaBaseDatabaseService.getFamilyByCode(code);
    if (familyResult.isSuccessful) {
      profile!.family = familyResult.data!.id;
      final profileResult = await SupaBaseDatabaseService.updateProfile(profile);
      if (profileResult.isSuccessful) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Launch the wifi credentials entering page.
  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(urlToLaunch))) {
      context.showErrorSnackBar(message: "Could not launch url...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkDetails = ModalRoute.of(context)!.settings.arguments as List<String>;
    ssid = networkDetails[0];
    password = networkDetails[1];

    return ScrollablePage(
      child: Column(
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
                "Device setup",
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              // Transparent icon for equal spacing.
              InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.logout,
                    size: 36,
                    color: Colors.transparent,
                  ))
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          // Page subtitle
          Text(
            "Please enter a unique family invite code for your family. Once the device setup is done family members can enter this to join the family.",
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30.h,
          ),
          const Text(
            "Invite code for family members",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.h,
          ),
          // invite code textfield
          CustomTextField(
            controller: inviteCodeController,
            hintText: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40.h,
          ),
          CustomRoundedButton(
            text: "Connect to device",
            onPressed: () async {
              family.inviteCode = inviteCodeController.text;

              final familyCreationResult = await SupaBaseDatabaseService.insertFamily(family);
              if (familyCreationResult.isSuccessful) {
                final successfullyJoinedFamily = await joinFamilyByCode(family.inviteCode);
                if (successfullyJoinedFamily) {
                  WiFiForIoTPlugin.connect(
                    ssid,
                    password: password,
                    joinOnce: true,
                  ).then(
                    (successfullyConnected) async {
                      final currentSSID = await WiFiForIoTPlugin.getSSID();
                      if (successfullyConnected || (currentSSID != null && currentSSID.startsWith("Aquacius"))) {
                        // Open browser url to enter wifi credentials.
                        _launchUrl();
                      } else {
                        if (mounted) {
                          context.showErrorSnackBar(message: "Could not connect to device :(");
                        }
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  );
                } else {
                  context.showErrorSnackBar(message: "Could not join family");
                }
              } else {
                if (mounted) {
                  context.showErrorSnackBar(message: "Could not create family: ${familyCreationResult.message!}");
                }
              }
            },
          )
        ],
      ),
    );
  }
}
