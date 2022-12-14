import 'dart:async';

import 'package:Aquecius/constants.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiListScreen extends StatefulWidget {
  const WifiListScreen({super.key});

  @override
  State<WifiListScreen> createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  // The SSID of the Aquacius devices.
  String ssidToLookFor = "Aquacius";
  // The password of the Aquacius devices.
  String password = "password";
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
              ? const CircularProgressIndicator()
              : Column(
                  children: accessPoints
                      .where((element) => element.ssid.startsWith(ssidToLookFor))
                      .map((e) => GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, '/setup_device', arguments: [e.ssid, password]);
                            },
                            child: Padding(
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
                            ),
                          ))
                      .toList(),
                ),
          SizedBox(
            height: 20.h,
          ),
          CustomRoundedButton(
            text: "??? Refresh ???",
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
