import 'dart:async';

import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wifi_scan/wifi_scan.dart';

// TODO:
// 1.	Connect to device
// 2.	Create family on local device. (we don’t have internet access)
// 3.	Send wifi creds and family id to device.
// 4.	Wait for device to connect to the wifi network. (and you consequently connect back to internet)
// 5.	Wait for a shower to be created with it’s family id set to the local family id.
// 6.	Add the family to the database, and add yourself to that family => setup complete.

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
    if (can == CanGetScannedResults.yes) {
      // listen to onScannedResultsAvailable stream
      subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
        // update accessPoints
        setState(() => accessPoints = results);
      });
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
            "Please turn on the device and stay near it.\nWait for the device to show up in the list below.",
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
                      .where((element) => element.ssid.startsWith(ssidToLookFor))
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
            onPressed: () async {
              subscription?.cancel();
              setState(() {
                accessPoints = [];
              });
              await Future.delayed(Duration(milliseconds: 500));
              startListeningToScannedResults();
            },
          )
        ],
      ),
    );
  }
}
