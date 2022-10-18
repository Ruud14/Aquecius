import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/cards.dart';
import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late ShowerSession session;
  double? averageConsumptionOfLastWeek;
  double? averageDurationOfLastWeek;
  double? averageTemperatureOfLastWeek;
  int? consumptionIncreasePercentage;
  int? durationIncreasePercentage;
  int? temperatureIncreasePercentage;
  bool triedFetchingAverages = false;
  Color circleColor = Colors.transparent;

  /// Populate the averages of last week.
  void getAverageData() async {
    final cons = await SupaBaseDatabaseService.getPastConsumptionAverage(session);
    final dur = await SupaBaseDatabaseService.getPastDurationAverage(session);
    final temp = await SupaBaseDatabaseService.getPastTemperatureAverage(session);
    if (cons.isSuccessful && dur.isSuccessful && temp.isSuccessful) {
      averageConsumptionOfLastWeek = cons.data.toDouble();
      averageDurationOfLastWeek = int.parse(dur.data.toString().split(":")[1]).toDouble();
      averageTemperatureOfLastWeek = temp.data;

      consumptionIncreasePercentage = (((session.consumption - averageConsumptionOfLastWeek!) / averageConsumptionOfLastWeek!) * 100).round();
      durationIncreasePercentage = (((session.durationMinutes - averageDurationOfLastWeek!) / averageDurationOfLastWeek!) * 100).round();
      temperatureIncreasePercentage = (((session.averageTemperature - averageTemperatureOfLastWeek!) / averageTemperatureOfLastWeek!) * 100).round();

      double colorFactor = (consumptionIncreasePercentage! + durationIncreasePercentage! + temperatureIncreasePercentage!) / -100;
      if (colorFactor > 1) {
        colorFactor = 1;
      } else if (colorFactor < -1) {
        colorFactor = -1;
      }
      Color c = Colors.green;
      if (colorFactor < 0) {
        c = Colors.red;
      }

      circleColor = Color.alphaBlend(Colors.orange.withOpacity(0.2), c.withOpacity(colorFactor.abs()));
      setState(() {});
    } else {
      if (mounted) {
        context.showErrorSnackBar(message: "Could not fetch recent averages");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Get the session from the previous route.
    session = ModalRoute.of(context)!.settings.arguments as ShowerSession;
    if (!triedFetchingAverages) {
      triedFetchingAverages = true;
      getAverageData();
    }
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
            backgroundColor: circleColor,
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
            height: 40.sp,
          ),
          // TODO: Change to real differences.
          // Differences from the usual.
          averageConsumptionOfLastWeek == null ? const CircularProgressIndicator() : generateDifferencesTexts(),

          SizedBox(
            height: 30.sp,
          ),
          // Motivational thingy
          Text(
            "(TEMP) Decrease your shower time by 1 more minute and you’ll beat Alice! 🏆",
            style: TextStyle(fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 60.sp,
          ),
          // Save button
          CustomRoundedButton(
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

  /// Generates the text with weekly differences.
  Widget generateDifferencesTexts() {
    const red = Color(0xFFAD0606);
    const green = Color(0xFF008F17);

    return Column(
      children: [
        Text(
          "${session.points} points earned!",
          style: TextStyle(fontSize: 20.sp, color: Colors.yellow),
        ),
        SizedBox(
          height: 20.sp,
        ),
        Text(
          "${consumptionIncreasePercentage!.abs()}% ${session.consumption > averageConsumptionOfLastWeek! ? 'more' : 'less'} water than the week before 💦",
          style: TextStyle(fontSize: 20.sp, color: session.consumption > averageConsumptionOfLastWeek! ? red : green),
        ),
        SizedBox(
          height: 10.sp,
        ),
        Text(
          "${temperatureIncreasePercentage!.abs()}% ${session.averageTemperature > averageTemperatureOfLastWeek! ? 'hotter' : 'colder'} than the week before ${session.averageTemperature > averageTemperatureOfLastWeek! ? '🥵' : '🥶'}",
          style: TextStyle(fontSize: 20.sp, color: session.averageTemperature > averageTemperatureOfLastWeek! ? red : green),
        ),
        SizedBox(
          height: 10.sp,
        ),
        Text(
          "${durationIncreasePercentage!.abs()}% ${session.durationMinutes > averageDurationOfLastWeek! ? 'longer' : 'shorter'} than the week before ⌛",
          style: TextStyle(fontSize: 20.sp, color: session.durationMinutes > averageDurationOfLastWeek! ? red : green),
        ),
      ],
    );
  }
}
