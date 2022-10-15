import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/cards.dart';
import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late ShowerSession session;

  @override
  Widget build(BuildContext context) {
    /// Get the session from the previous route.
    session = ModalRoute.of(context)!.settings.arguments as ShowerSession;
    return ScrollablePage(
      bottomNavigationBar: const BottomCardsNavigationBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                "Summary",
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
            "${session.startedAt.day}-${session.startedAt.month}-${session.startedAt.year}",
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 40.sp,
          ),

          // Summary circle
          CircleAvatar(
            radius: 120.sp,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 105.sp,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/waterdrop.png",
                        width: 27.sp,
                        height: 27.sp,
                      ),
                      SizedBox(
                        width: 8.sp,
                      ),
                      Text(
                        "${session.consumption.round()} L",
                        style: TextStyle(color: Colors.white, fontSize: 27.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/fire.png",
                        width: 27.sp,
                        height: 27.sp,
                      ),
                      SizedBox(
                        width: 8.sp,
                      ),
                      Text(
                        "${session.averageTemperature} °C ",
                        style: TextStyle(color: Colors.white, fontSize: 27.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/time.png",
                        width: 27.sp,
                        height: 27.sp,
                      ),
                      SizedBox(
                        width: 8.sp,
                      ),
                      Text(
                        "${session.durationMinutes} min",
                        style: TextStyle(color: Colors.white, fontSize: 27.sp),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: 30.sp,
          ),
          // TODO: Change to real differences.
          // Differences from the usual.
          Text(
            "20% more water than the week before 💦",
            style: TextStyle(fontSize: 20.sp, color: const Color(0xFFAD0606)),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            "1% hotter than the week before 🥵",
            style: TextStyle(fontSize: 20.sp, color: const Color(0xFF938D01)),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            "7 min shorter than the week before ⌛",
            style: TextStyle(fontSize: 20.sp, color: const Color(0xFF008F17)),
          ),

          SizedBox(
            height: 30.sp,
          ),
          // Motivational thingy
          Text(
            "Decrease your shower time by 1 more minute and you’ll beat Alice! 🏆",
            style: TextStyle(fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 60.sp,
          ),
          // Save button
          PurpleButton(
            text: "Share progress",
            onPressed: () {
              // TODO: Add session sharing
            },
            extraHorizontalPadding: 40,
          ),
          SizedBox(
            height: 20.sp,
          ),
        ],
      ),
    );
  }
}
