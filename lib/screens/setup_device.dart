import 'dart:async';

import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SetupDeviceScreen extends StatefulWidget {
  const SetupDeviceScreen({super.key});

  @override
  State<SetupDeviceScreen> createState() => _SetupDeviceScreenState();
}

class _SetupDeviceScreenState extends State<SetupDeviceScreen> {
  // The SSID of the Aquacius devices.
  String ssidToLookFor = "Aquacius";
  // initialize accessPoints and subscription
  List<WiFiAccessPoint> accessPoints = [];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  void startListeningToScannedResults() async {
    // check platform support and necessary requirements
    final can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        // listen to onScannedResultsAvailable stream
        subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
          // update accessPoints
          setState(() => accessPoints = results);
        });
        // ...
        break;
      // ... handle other cases of CanGetScannedResults values
    }
  }

  @override
  dispose() {
    super.dispose();
    // Stop listening to networks.
    subscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    // Listen for nearby networks.
    startListeningToScannedResults();
  }

  @override
  Widget build(BuildContext context) {
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
                "Setup device",
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
            "Please turn on the device\nand stay near it.",
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          accessPoints.isEmpty
              ? CircularProgressIndicator()
              : Column(
                  children: accessPoints
                      .where((element) => element.ssid == ssidToLookFor)
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(22)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    e.ssid,
                                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    "${e.level.toString()}dBm",
                                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
          SizedBox(
            height: 20.h,
          ),
          CustomRoundedButton(
            text: "⟳ Refresh ⟳",
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              subscription?.cancel();
              setState(() {
                accessPoints = [];
              });
              startListeningToScannedResults();
            },
          )
        ],
      ),
    );
  }
}
